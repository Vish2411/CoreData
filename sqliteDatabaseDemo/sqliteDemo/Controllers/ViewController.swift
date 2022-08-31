//
//  ViewController.swift
//  sqliteDemo
//
//  Created by iMac on 29/08/22.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var mytableView: UITableView!
    
    //MARK: - VARIABLE DECLARE
    var EmployeeData = [ModelEmployee]()
    
    //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NSNotification.Name("Update"), object: nil)
        tableCEllRegister()
        mytableView.delegate = self
        mytableView.dataSource = self
        
        Dbmanager.shared.getEmployeeList { array in
            self.EmployeeData = array
            self.mytableView.reloadData()
        } compliationError: { error in
            self.showAlert(title: "Error", okTitle: "OK", message: error.localizedDescription, sucess: nil)
        }
    }
    
    
    @objc func updateData() {
        Dbmanager.shared.getEmployeeList { array in
            self.EmployeeData = array
            self.mytableView.reloadData()
        } compliationError: { error in
            self.showAlert(title: "Error", okTitle: "OK", message: error.localizedDescription, sucess: nil)
        }
    }
    
    @IBAction func btnAddAction(_ sender: UIBarButtonItem) {
        let Svc = self.storyboard?.instantiateViewController(withIdentifier: "addUserDataViewController") as! addUserDataViewController
        Svc.selectedData = nil
        self.navigationController?.pushViewController(Svc, animated: true)
    }
    
    
}

//MARK: - Table View Delegate & Detsource Method
extension ViewController : UITableViewDelegate,UITableViewDataSource{

    private func tableCEllRegister(){
        self.mytableView.register(UINib(nibName: "TableViewCell1", bundle: nil), forCellReuseIdentifier: "TableViewCell1")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EmployeeData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mytableView.dequeueReusableCell(withIdentifier: "TableViewCell1", for: indexPath) as? TableViewCell1 else{return .init()}
        cell.labelUserName.text = EmployeeData[indexPath.row].name
        cell.labelUserDesignation.text = EmployeeData[indexPath.row].designation
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let svc = self.storyboard?.instantiateViewController(withIdentifier: "addUserDataViewController") as! addUserDataViewController
        svc.selectedData = EmployeeData[indexPath.row]
        self.navigationController?.pushViewController(svc, animated:true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Dbmanager.shared.deleteEmployeeData(EmployeeData[indexPath.row],
            compliationSucess: {
                self.EmployeeData.remove(at: indexPath.row)
                self.updateData()
                
            }, compliationError: { error in
                print(error.localizedDescription)
            })
        }
    }
    
}

