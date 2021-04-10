//
//  ViewController.swift
//  Memofy2
//
//  Created by JACKY on 23/03/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var planIndex = 100
    var sections: [String] = []
    let backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.9725490196, alpha: 1)
    let defaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    
    var plans: [Plan] = [] //TEMP ARCHIVER
    
    var todoPlans: [Plan] = []
    var completedPlans: [Plan] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        let nib = UINib(nibName: "MemoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("ollaaaa tassjas")
        setupView()
    }
    //navEditPlan
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
                let vc = nav.topViewController as? EditPlanViewController {
                vc.receivedPlanIndex = planIndex
        }
          
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
            if(todoPlans.count > 0) {
                sections.append("To Do")
            }
            if(completedPlans.count > 0) {
                sections.append("Completed")
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
        planIndex = 1000
        self.performSegue(withIdentifier: "navEditPlan", sender: self)
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
        let sectionsCount = sections.count
        if(sectionsCount == 2) {
            if section == 0 {
                return todoPlans.count
            }
            else {
                return completedPlans.count
            }
        }
        else if(sectionsCount == 1){
            return todoPlans.count > 0 ? todoPlans.count : completedPlans.count
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor =  backgroundColor
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
                let sectionsCount = sections.count
                if(sectionsCount == 2) {
                    if indexPath.section == 0 {
                        tempData = todoPlans[indexPath.row]
                    }
                    else {
                        tempData = completedPlans[indexPath.row]
                    }
                }
                else if(sectionsCount == 1){
                    tempData = todoPlans.count > 0 ? todoPlans[indexPath.row] : completedPlans[indexPath.row]
                }else{
                    tempData = todoPlans.count > 0 ? todoPlans[indexPath.row] : completedPlans[indexPath.row]
                }
        //                if(indexPath.section == 0){
//                    tempData = todoPlans[indexPath.row]
//                }else{
//                    tempData = completedPlans[indexPath.row]
//                }
                cell.nameLabel.text = tempData.studyPlan
                cell.nameLabel.textColor =  #colorLiteral(red: 0, green: 0.3607843137, blue: 0.7254901961, alpha: 1)
                print("index", tempData.index)
                cell.dateLabel.text = formatDateToString(date: tempData.startsDate)
                
                return cell
    }
    
    
}
