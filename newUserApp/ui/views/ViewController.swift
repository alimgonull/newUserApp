//
//  ViewController.swift
//  newUserApp
//
//  Created by Alim Gönül on 26.09.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var nameArray = [String]()
    var numberArray = [String]()
    var idArray = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:#selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    @objc func getData(){
        nameArray.removeAll(keepingCapacity: false)
        numberArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject] {
                
                if let userName = result.value(forKey: "name") as? String{
                    nameArray.append(userName)
                }
                if let userNumber = result.value(forKey: "number") as? String {
                    numberArray.append(userNumber)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    idArray.append(id)
                }
                tableView.reloadData()
            }
            
        }
        catch{
            print("Error")
        }
    }
}
extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CellView
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.numberLabel.text = numberArray[indexPath.row]
        return cell
    }
}
