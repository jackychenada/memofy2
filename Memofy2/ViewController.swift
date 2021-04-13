//
//  ViewController.swift
//  Memofy2
//
//  Created by JACKY on 23/03/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var mainLabel: UILabel!
    
    var planIndex = -1
    var sections: [String] = []
    let backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.9725490196, alpha: 1)
    let defaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    
    var plans: [Plan] = [] //TEMP ARCHIVER
    var todoPlans: [Plan] = []
    var incomingPlans: [Plan] = []
    var completedPlans: [Plan] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let nib = UINib(nibName: "MemoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        setupInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupView()
    }
    //navEditPlan
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
                let vc = nav.topViewController as? EditPlanViewController {
                vc.receivePlanIndex = planIndex
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        //jangan dihapus ya, kepake untuk segue back ke main
    }
    
    func setupInterface(){
        let footerView =  UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ))
        footerView.backgroundColor = backgroundColor
        tableView.tableFooterView = footerView
    }
    
    func clearArr() {
        todoPlans = []
        incomingPlans = []
        completedPlans = []
        sections = []
    }
    
    func setupView(){
        print("masuk setupView")
        //UserDefaults.standard.removeObject(forKey: "Plans")
        clearArr()
        let tempArchiveItems = defaults.data(forKey: "Plans")
        print("tempArchiveItems ", tempArchiveItems as Any)
        
        if(tempArchiveItems != nil){
            plans = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tempArchiveItems!) as! [Plan]
            print("INI MEMOS", plans as Any)
            for plan in plans {
                if plan.status == "in progress" {
                    todoPlans.append(plan)
                }
                else if plan.status == "completed" {
                    completedPlans.append(plan)
                }
                else if plan.status == "in coming" {
                    incomingPlans.append(plan)
                }
            }
            if(todoPlans.count > 0) {
                sections.append("TO DO")
            }
            if(incomingPlans.count > 0) {
                sections.append("INCOMING")
            }
            if(completedPlans.count > 0) {
                sections.append("COMPLETED")
            }
            tableView.reloadData()
            //print("ALL USER DEFAULT", UserDefaults.standard.dictionaryRepresentation())
        }
    }
    
    func formatDateToString(date: Date) -> String {
        dateFormatter.dateFormat = "MMM dd - hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSection = sections[indexPath[0]]
        if(currentSection == "TO DO"){
            planIndex = todoPlans[indexPath[1]].index
        }
        else if(currentSection == "INCOMING"){
            planIndex = incomingPlans[indexPath[1]].index
        }
        else if(currentSection == "COMPLETED"){
            planIndex = completedPlans[indexPath[1]].index
        }
        self.performSegue(withIdentifier: "navEditPlan", sender: self)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        if(currentSection == "TO DO"){
            return todoPlans.count
        }
        else if(currentSection == "INCOMING"){
            return incomingPlans.count
        }
        else if(currentSection == "COMPLETED"){
            return completedPlans.count
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
        let label = UILabel(frame: CGRect(x: 12, y: 0, width: tableView.bounds.size.width, height: 50))
        label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.6)
        label.text = sections[section]
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as! MemoTableViewCell
                var tempData:Plan
                
                let currentSection = sections[indexPath.section]
                if(currentSection == "TO DO"){
                    tempData = todoPlans[indexPath.row]
                }
                else if(currentSection == "COMPLETED"){
                    tempData = completedPlans[indexPath.row]
                }
                else if(currentSection == "INCOMING"){
                    tempData = incomingPlans[indexPath.row]
                }
                else{
                    tempData = todoPlans.count > 0 ? todoPlans[indexPath.row] : completedPlans[indexPath.row]
                }
                cell.nameLabel.text = tempData.studyPlan
                cell.nameLabel.textColor =  #colorLiteral(red: 0, green: 0.3607843137, blue: 0.7254901961, alpha: 1)
                print("index", tempData.index)
                cell.dateLabel.text = formatDateToString(date: tempData.startsDate)
                return cell
    }
    
}
