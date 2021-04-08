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
    
    //Tassja
    
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
    
    let sections = ["To Do", "Completed"]
    let defaults = UserDefaults.standard
    
    var tasks: [Task] = [] //FEED
    var memos: [Task] = [] //TEMP ARCHIVER
    
    var todoPlans: [Task] = []
    var completedPlans: [Task] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.9725490196, alpha: 1)
        // sometest test
        func addTask(name: String, status: String){
            let newTask = Task(name: name, status: status)
            tasks.append(newTask)
        }
        
        func addMemo(name: String, status: String){
            let newTask = Task(name: name, status: status)
            memos.append(newTask)
        }
        
        //GETTER - USER DEFAULTS
        let tempArchiveItems = defaults.data(forKey: "SavedDict")
        print("tempArchiveItems ", tempArchiveItems as Any)
        
        memos = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tempArchiveItems!) as! [Task]
        print("INI MEMOS", memos as Any)
        print("memos index 0", memos[0].name)
        addMemo(name: "programmer", status: "in progress")
        addMemo(name: "design", status: "in progress")
        
        for memo in memos {
            if memo.status == "in progress" {
                todoPlans.append(memo)
            }
            else if memo.status == "completed" {
                completedPlans.append(memo)
            }
        }
        print("TODO PLANS:", todoPlans)
        print("completed PLANS:", completedPlans)
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
        
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexpath", indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //self.tableView.estimatedRowHeight = 120
        return UITableView.automaticDimension
    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return memos.count
        if section == 0 {
            return todoPlans.count
        }
        else {
            return completedPlans.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.9725490196, alpha: 1)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        label.text = sections[section]
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as! MemoTableViewCell
                var tempData:Task
                if(indexPath.section == 0){
                    tempData = todoPlans[indexPath.row]
                }else{
                    tempData = completedPlans[indexPath.row]
                }
                let data = tempData
                cell.nameLabel.text = data.name + " memo"
                cell.nameLabel.textColor = #colorLiteral(red: 0, green: 0.3607843137, blue: 0.7254901961, alpha: 1)
                cell.dateLabel.text = data.status
                return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = UITableView.automaticDimension
//    }
    
    
}
