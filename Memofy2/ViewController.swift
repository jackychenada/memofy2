//
//  ViewController.swift
//  Memofy2
//
//  Created by JACKY on 23/03/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    let sections = ["To Do", "Completed"]
    let defaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    
    var plans: [Plan] = [] //TEMP ARCHIVER
    
    var todoPlans: [Plan] = []
    var completedPlans: [Plan] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let nib = UINib(nibName: "MemoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("ollaaaa tassja")
        setupView()
    }
    
    func clearArr() {
        todoPlans = []
        completedPlans = []
    }
    
    func setupView(){
        print("olla ollll")
        //GETTER - USER DEFAULTS
        //UserDefaults.standard.removeObject(forKey: "Plans")
        clearArr()
        let tempArchiveItems = defaults.data(forKey: "Plans")
        print("tempArchiveItems ", tempArchiveItems as Any)
        
        if(tempArchiveItems != nil){
            plans = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tempArchiveItems!) as! [Plan]
            print("INI MEMOS", plans as Any)
            //addMemo(name: "programmer", status: "in progress")
            //addMemo(name: "design", status: "in progress")
            for plan in plans {
                print("plans index 0", plans[0].status)
                print("ini plan", plan)
                if plan.status == "in progress" {
                    todoPlans.append(plan)
                }
                else if plan.status == "completed" {
                    completedPlans.append(plan)
                }
            }
            print("TODO PLANS:", todoPlans)
            print("completed PLANS:", completedPlans)
            tableView.reloadData()
            //print("ALL USER DEFAULT", UserDefaults.standard.dictionaryRepresentation())
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(sections.count == 2) {
            //to do
            if(indexPath[0] == 0) {
                print("todo plans index", todoPlans[indexPath[1]].index)
            }
            //completed
            else if(indexPath[1] == 1) {
                print("completed plans index", completedPlans[indexPath[1]].index)
            }
        }
        else{
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //self.tableView.estimatedRowHeight = 120
        return UITableView.automaticDimension
    }

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
        headerView.backgroundColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        label.text = sections[section]
        headerView.addSubview(label)
        return headerView
    }
    
    func formatDateToString(date: Date) -> String {
        dateFormatter.dateFormat = "MMM dd - hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as! MemoTableViewCell
                var tempData:Plan
                if(indexPath.section == 0){
                    tempData = todoPlans[indexPath.row]
                }else{
                    tempData = completedPlans[indexPath.row]
                }
                let data = tempData
                cell.nameLabel.text = data.studyPlan
                cell.nameLabel.textColor =  #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                print("index", data.index)
                cell.dateLabel.text = formatDateToString(date: data.startsDate)
                return cell
    }
    
    
}
