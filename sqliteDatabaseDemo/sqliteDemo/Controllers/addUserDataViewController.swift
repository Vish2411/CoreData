//
//  addUserDataViewController.swift
//  sqliteDemo
//
//  Created by iMac on 29/08/22.
//

import UIKit

class addUserDataViewController: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var textUserMobile: UITextField!
    @IBOutlet weak var btnSaved: UIButton!
   
//    var userFor:Status = .New
//    enum Status{
//        case New
//        case isEdit
//    }
    
    var selectedData:ModelEmployee?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpData()
    }
    
    func setUpData(){
        if let employee = selectedData {                            // Optional Binding
            self.textUserName.text = employee.name
            self.textUserMobile.text = employee.designation
            self.btnSaved.setTitle("Update!", for: .normal)
        }else{
            self.textUserName.text = ""
            self.textUserMobile.text = ""
            self.btnSaved.setTitle("Saved", for: .normal)
        }
    }
    
    @IBAction func btnSaveddAction(_ sender: Any) {
        
        guard let name = self.textUserName.text, name.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 , let designation = self.textUserMobile.text, designation.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {return}
        
        if var employee = selectedData{
            employee.name = name
            employee.designation = designation
            
            Dbmanager.shared.updateEmployeeData(employee) {
                NotificationCenter.default.post(name: NSNotification.Name("Update"), object: nil)
                self.showAlert(okTitle: "Show Update Data", message: "Your Data Are Updated In Sqlite Database") {
                    self.navigationController?.popViewController(animated: true)
                }
            } compliationError: { error in
                self.showAlert(title: "Error!", message: error.localizedDescription)
            }


            
        }else{
            let employee = ModelEmployee.init(name: name, designation: designation)
            Dbmanager.shared.insertEmployeeData(employee) {
                NotificationCenter.default.post(name: NSNotification.Name("Update"), object: nil)
                self.showAlert(okTitle: "Show Data", message: "Your Data Are Added Successfully In Sqlite Database") {
                    self.navigationController?.popViewController(animated: true)
                }
            } compliationError: { error in
                self.showAlert(title: "Error!", message: error.localizedDescription)
            }

        }
        
    }

}

extension UIViewController {
    
    func showAlert(title: String = "Successed",okTitle:String = "ok",message: String ,sucess: (()->())? = nil){
        let Success = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        let ok = UIAlertAction.init(title: okTitle, style: .default) { UIAlertAction in
            sucess?()
        }
        Success.addAction(ok)
        self.present(Success, animated: true, completion: nil)
    }
}
