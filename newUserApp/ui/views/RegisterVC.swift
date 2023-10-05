//
//  RegisterVC.swift
//  newUserApp
//
//  Created by Alim Gönül on 26.09.2023.
//

import UIKit
import CoreData
class RegisterVC: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var userNumberText: UITextField!
    
    var selectedName = ""
    var selectedNameId : UUID?
    
    var choosenName = ""
    var chosenNumber = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedName != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            // id'yi Stringe çeviriyoruz
            
            let idString = selectedNameId!.uuidString
            request.predicate = NSPredicate(format: "id = %@", idString)
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let userName = result.value(forKey: "name") as? String {
                            choosenName = userName
                            
                        }
                        if let userNumber = result.value(forKey: "number") as? String {
                            chosenNumber = userNumber
                            
                        }
                    }
                }
                
            }catch {
                    print("Error")
            }
        }
        
       
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let users = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        users.setValue(userNameText.text, forKey: "name")
        users.setValue(userNumberText.text, forKey: "number")
        
        users.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("success")
        }
        catch{
            print("Error")
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object:nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
