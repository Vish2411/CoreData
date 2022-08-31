//  Dbmanager.swift
//  sqliteDemo
//
//  Created by iMac on 30/08/22.
//

import UIKit
import FMDB

class Dbmanager: NSObject {
    
    static let shared = Dbmanager()
    
    private let databaseFileName = "database.sqlite"
    private var pathToDatabase: String!
    private var database: FMDatabase!
    private let tableName  = "EmployeeTable"
    
    private let field_ID = "ID"
    private let field_Name = "name"
    private let field_Designation = "designation"
    
    override init() {
        super.init()
     
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        print(documentsDirectory)
    }
    
    func createDatabase() -> Bool {
        var created = false
     
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                created = true
                createTable()
            }
        }else {
            database = FMDatabase(path: pathToDatabase!)
        }
        return created
    }
    
    func openDataBase(){
        if !database.isOpen {
            database.open()
        }
    }
    
    func closeDataBase(){
        if database.isOpen {
            database.close()
        }
    }
    
    func createTable() {
        openDataBase()
        let createEmployeeTableQuery = "create table \(self.tableName) (\(field_ID) text primary key not null, \(field_Name) text not null, \(field_Designation) text not null)"
            
        do {
            try database.executeUpdate(createEmployeeTableQuery, values: nil)
            print("Table Is cretaed and executed")
        }
        catch {
            print("Could not create table.")
            print(error.localizedDescription)
        }
    }
    
    // For Insert data in Sqlite database
    func insertEmployeeData(_ employee: ModelEmployee, compliationSucess: @escaping(()->Void),compliationError: @escaping((_ error:Error)->Void)){
        
        openDataBase()
        do{
            let query = "insert into \(self.tableName) (\(field_ID), \(field_Name), \(field_Designation)) values ('\(employee.id)' , '\(employee.name)', '\(employee.designation)');"
            
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
                compliationError(database.lastError())
            }else{
                compliationSucess()
            }
        } catch let error {
            compliationError(error)
        }
        
        database.close()
    }
    
    // For Data Fetch
    func getEmployeeList(compliationSucess: @escaping(([ModelEmployee])->()), compliationError: @escaping((_ error:Error)->Void)){
        openDataBase()
        let query = "SELECT * FROM \(tableName);"
        var res = [ModelEmployee]()
        do {
            let results = try database.executeQuery(query, values: nil)
            while results.next() {
                let model = ModelEmployee(id: String(results.string(forColumn: self.field_ID)!), name: String(results.string(forColumn: self.field_Name)!), des: String(results.string(forColumn: self.field_Designation)!))
                res.append(model)
            }
            print(res)
            compliationSucess(res)
        }
        catch {
            compliationError(error)
        }
    }
 
    //  For update Data
    func updateEmployeeData(_ employee:ModelEmployee, compliationSucess: @escaping(()->()), compliationError: @escaping((_ error:Error)->Void)) {
        openDataBase()
        let query = "update \(tableName) set \(field_Name)= '\(employee.name)', \(field_Designation)='\(employee.designation)' where \(field_ID)='\(employee.id)'"
        
        do {
            try database.executeUpdate(query, values: [employee])
            compliationSucess()
        }
        catch {
            compliationError(error)
            print(error.localizedDescription)
        }
        
        database.close()
    }
    
    // For Delete data
    func deleteEmployeeData(_ employee:ModelEmployee, compliationSucess: @escaping(()->()), compliationError: @escaping((_ error:Error)->Void)){
        
        openDataBase()
        let query = "delete from \(tableName) where \(field_ID)=?"
        
        do {
            try database.executeUpdate(query, values: [employee.id])
            compliationSucess()
        }
        catch {
            compliationError(error)
            print(error.localizedDescription)
        }
        
        database.close()
    }
}
