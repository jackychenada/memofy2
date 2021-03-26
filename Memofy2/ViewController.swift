//
//  ViewController.swift
//  Memofy2
//
//  Created by JACKY on 23/03/21.
//

import UIKit

class Task
{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func addTask(name: String, status: String){
            let newTask = Task(name: name, status: status)
            tasks.append(newTask)
        }

        addTask(name: "makan", status: "in progress")
        addTask(name: "makan", status: "in progress")
        addTask(name: "makan", status: "completed")
        
        let nib = UINib(nibName: "MemoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as! MemoTableViewCell
                cell.nameLabel.text = tasks[indexPath.row].name
                cell.dateLabel.text = tasks[indexPath.row].status
                return cell
    }
    
    
}
