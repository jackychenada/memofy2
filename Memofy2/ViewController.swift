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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupView()
        setupInterface()
    }
    //navEditPlan
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
                let vc = nav.topViewController as? EditPlanViewController {
                vc.receivePlanIndex = planIndex
        }
    }
    
    //TOLONG JANGAN DIHAPUS
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        //jangan dihapus ya, kepake untuk segue back ke main
    }
    
    func setupInterface(){
        let initHeight = 680
        let tableHeight = (todoPlans.count + completedPlans.count + incomingPlans.count) * 68
        let calcHeight = initHeight - tableHeight
        let footerHeight = CGFloat(calcHeight > -1 ? calcHeight : 0)
        let footerView =  UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: footerHeight ))
        footerView.backgroundColor = backgroundColor
        tableView.tableFooterView = footerView
    }
    
    func clearArr() {
        todoPlans = []
        incomingPlans = []
        completedPlans = []
        sections = []
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let retBool = false
        let date1String = formatDateToString(date: date1, formatDate: "yy-MM-dd")
        let date2String = formatDateToString(date: date2, formatDate: "yy-MM-dd")
        if(date1String == date2String){
            return true
        }
        return retBool
    }
    
    func setupView(){
        let currentDate = Date()
        let currentDateString = formatDateToString(date: currentDate, formatDate: "yyMMdd")
        let currentDateInt = Int(currentDateString) ?? 0
        let currentDay = Calendar.current.component(.weekday, from: currentDate)
        
        //UserDefaults.standard.removeObject(forKey: "Plans")
        clearArr()
        getUserDefault()
        print("current date int", currentDateInt)
        for plan in plans {
            let startDateString = formatDateToString(date: plan.startsDate, formatDate: "yyMMdd")
            let endDateString = formatDateToString(date: plan.endsDate, formatDate: "yyMMdd")
            let startDateInt = Int(startDateString) ?? 0
            let endDateInt = Int(endDateString) ?? 0
        
            if(startDateInt <= currentDateInt && endDateInt >= currentDateInt) {

                let currentIsSameDayWithLastStudy = isSameDay(date1: currentDate, date2: plan.lastFinishStudy)
                
                if(plan.status == "completed" && plan.frequency.count > 0 && !currentIsSameDayWithLastStudy){
                    let frequencyIndex = plan.frequency.firstIndex(of: currentDay) ?? -1
                    let haveRepeatToday = frequencyIndex > -1 ? true : false
                    if(haveRepeatToday){
                        plan.status = "in progress"
                    }
                }
                if(plan.status == "incoming" && currentDateInt >= startDateInt) {
                    plan.status = "in progress"
                }
            }

            if plan.status == "in progress" {
                todoPlans.append(plan)
            }
            else if plan.status == "completed" {
                completedPlans.append(plan)
            }
            else if plan.status == "incoming" {
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
        setUserDefault()
    }
    
    func getUserDefault(){
        let tempArchiveItems = defaults.data(forKey: "Plans")
        print("tempArchiveItems ", tempArchiveItems as Any)
        if(tempArchiveItems != nil){
            plans = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tempArchiveItems!) as! [Plan]
        }
    }
    
    func setUserDefault(){
        let preStorePlans = try! NSKeyedArchiver.archivedData(withRootObject: plans, requiringSecureCoding: false)
        defaults.set(preStorePlans, forKey: "Plans")
    }
    
    func formatDateToString(date: Date, formatDate: String) -> String {
        dateFormatter.dateFormat = formatDate
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
                cell.dateLabel.text = formatDateToString(date: tempData.startsDate, formatDate: "MMM dd - hh:mm a")
                return cell
    }
    
}
