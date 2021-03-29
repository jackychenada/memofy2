//
//  ViewController.swift
//  Memofy2
//
//  Created by JACKY on 23/03/21.
//

import UIKit

class Task: NSObject, NSCoding
{
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(status, forKey: "status")
        
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: "name") as? String,
              let status = coder.decodeObject(forKey: "status") as? String
            else { return nil }

            self.init(
                name: name,
                status: status
                //published: coder.decodeInteger(forKey: "published") //untuk Int
            )
    }
    
    var name: String
    var status: String
    init(name: String, status: String)
    {
        self.name = name
        self.status = status
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var tasks: [Task] = []
    var memos: [Task] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func addTask(name: String, status: String){
            let newTask = Task(name: name, status: status)
            tasks.append(newTask)
        }
        
        //GETTER - USER DEFAULTS
        let tempArchiveItems = defaults.data(forKey: "SavedDict")
        print("tempArchiveItems ", tempArchiveItems as Any)
        
        memos = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tempArchiveItems!) as! [Task]
        print("INI MEMOS", memos as Any)
//        addTask(name: "makan", status: "in progress")
//        addTask(name: "minum", status: "in progress")
//        addTask(name: "tidur", status: "completed")
        
        print("TASK SEBELUM DI ARCHIVE", tasks)
        
        //SETTER - USER DEFAULTS
//        let preStoreTasks = try! NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false)
//        print("INI DATA JADI BYTE", preStoreTasks)
        //defaults.set(preStoreTasks, forKey: "SavedDict")
        
        //print(defaults.object(forKey: "SavedDict") as Any )
        print("ALL USER DEFAULT", UserDefaults.standard.dictionaryRepresentation())
        
        //defaults.set(tasks, forKey: "")
        let nib = UINib(nibName: "MemoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as! MemoTableViewCell
                cell.nameLabel.text = memos[indexPath.row].name + " memo"
                cell.nameLabel.textColor = .red
                cell.dateLabel.text = memos[indexPath.row].status
                return cell
    }
    
    
}
