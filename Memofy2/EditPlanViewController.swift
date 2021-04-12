//
//  EditPlanViewController.swift
//  Memofy2
//
//  Created by Adinda Puji Rahmawaty on 04/04/21.
//

import UIKit

class EditPlanViewController: UITableViewController, RepeatEditDataDelegate {
    
    var dateFormatterr = DateFormatter()
    
    var receivePlanIndex:Int = -1
    
    var plans : [Plan] = []
    var days : [Int] = []
    
//    let planDummy = "Programming"
//    let noteDummy = "Swift Playground"
//    let statusDummy = "Completed"
    
    let defaults = UserDefaults.standard
    let formatDateString = "MMMM dd, yyyy"
    let formatTimeString = "HH:mm"
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var studyPlanTF: UITextField!
    @IBOutlet weak var studyNotesTextView: UITextView!
    
    @IBOutlet weak var repeatTableCell: UIView!
    @IBOutlet weak var repeatEditLabel: UILabel!
    
    @IBOutlet weak var dateStartsTableCell: UIView!
    @IBOutlet weak var dateStartsLabel: UILabel!
    @IBOutlet weak var dateStartsDatePicker: UIDatePicker!
    
    @IBOutlet weak var dateEndsTableCell: UIView!
    @IBOutlet weak var dateEndsLabel: UILabel!
    @IBOutlet weak var dateEndsDatePicker: UIDatePicker!
    
    @IBOutlet weak var timeReminderTableCell: UIView!
    @IBOutlet weak var timeReminderTimePicker: UIDatePicker!
    @IBOutlet weak var timeReminderSwitch: UISwitch!
    @IBOutlet weak var timeReminderTimeLabel: UILabel!
    
    @IBOutlet weak var studyDurationTableCell: UIView!
    @IBOutlet weak var studyDurationLabel: UILabel!
    @IBOutlet weak var studyDurationTimePicker: UIDatePicker!
    @IBOutlet weak var breakDurationTableCell: UIView!
    @IBOutlet weak var breakDurationLabel: UILabel!
    @IBOutlet weak var breakDurationTimePicker: UIDatePicker!

    
    @IBOutlet weak var startStudyButton: UIButton!
    
    var choosenRepeat: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("ABC")
        
//        studyPlanTF.text = String(planDummy)
//        studyNotesTextView.text = String(noteDummy)
        
        //Ngambil data dari repeat
        timeReminderTimeLabel.text = choosenRepeat
        
//        Set default date di add
        dateStartsDatePicker.date = NSDate() as Date
        dateEndsDatePicker.date = NSDate() as Date
        timeReminderTimePicker.date = NSDate() as Date

        hiddenViewDatePicker(fieldName: "init")

        dateFormatterr.dateStyle = DateFormatter.Style.long

        dateStartsLabel.text = formatDateToString(date: dateStartsDatePicker.date, formatDate: formatDateString)

        dateEndsLabel.text = formatDateToString(date: dateEndsDatePicker.date, formatDate: formatDateString)

        timeReminderTimeLabel.text = formatDateToString(date: timeReminderTimePicker.date, formatDate: formatTimeString)
//        timeReminderTimeLabel.text = dateFormatterr.string(from: timeReminderTimePicker.date)
        
        
        let tempArchiveItems = defaults.data(forKey: "Plans")
            if (tempArchiveItems != nil ) {
                plans = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tempArchiveItems!) as! [Plan]
                print("[view did load] Ini receive plan Index", receivePlanIndex)
                print("[view did load] ini studyPlan", plans[receivePlanIndex].studyPlan)
                let plan = plans[receivePlanIndex]
                
//                var plan = plans[0]
//
//                for plann in plans {
//                    print("Dari Home, gw dapet index object ke", receivePlanIndex)
//                    print("Ini plann index object ke ", plann.index)
//                    if plann.index == receivePlanIndex {
//                        // plan = index array, plann
//                        plan = plann
//                        print("Yang kepilih plann index yang ke ", plann.index)
//                        break
//                    }
//                }
                
                studyPlanTF.text = plan.studyPlan
                studyNotesTextView.text = plan.studyNotes
                repeatLabel(day: plan.frequency)
                dateStartsLabel.text = formatDateToString(date: plan.startsDate, formatDate: formatDateString)
                dateEndsLabel.text = formatDateToString(date: plan.endsDate, formatDate: formatDateString)
                timeReminderTimeLabel.text = formatDateToString(date: plan.timeReminder, formatDate: formatTimeString)
//                //ini buat switch, ga perlu diconvert
                timeReminderSwitch.isOn = plan.switchReminder
                lableDuration(label: studyDurationLabel, duration: plan.studyDuration)
                lableDuration(label: breakDurationLabel, duration: plan.breakDuration)
//                breakDurationLabel.text = String(plan.breakDuration)
            }
        
        let plan = plans
        if (plan[receivePlanIndex].status == "in progress" && plan[receivePlanIndex].status == "incoming") {
            startStudyButton.isEnabled = true
            startStudyButton.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            startStudyButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        } else if (plan[receivePlanIndex].status == "completed") {
            startStudyButton.isEnabled = false
            startStudyButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            startStudyButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        let tempArchiveItems = defaults.data(forKey: "Plans")
            if (tempArchiveItems != nil ) {
                plans = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tempArchiveItems!) as! [Plan]
                print(receivePlanIndex)
                print(plans[receivePlanIndex].studyPlan)
                let plan = plans[receivePlanIndex]
        
//                var plan = plans[0]
//
//                for plann in plans {
//                    print("Dari Home, gw dapet index object ke", receivePlanIndex)
//                    print("Ini plann index object ke ", plann.index)
//                    if plann.index == receivePlanIndex {
//                        // plan = index array, plann
//                        plan = plann
//                        print("Yang kepilih plann index yang ke ", plann.index)
//                        break
//                    }
//                }
        

        plan.studyPlan = studyPlanTF.text!
        plan.studyNotes = studyNotesTextView.text!
        plan.frequency = days
        plan.startsDate = dateStartsDatePicker.date
        plan.endsDate = dateEndsDatePicker.date
        plan.timeReminder = timeReminderTimePicker.date
        plan.switchReminder = timeReminderSwitch.isOn
        plan.studyDuration = Int(studyDurationTimePicker.countDownDuration)
        plan.breakDuration = Int(breakDurationTimePicker.countDownDuration)
    }
    }
    
    @IBAction func deletePlanButton(_ sender: Any) {
       
//
        let alert = UIAlertController(title: "Delete Plan", message: "This will delete current plan from the list", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (_) in
            print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
            
            let plan = self.plans[self.receivePlanIndex]
            plan.status = "removed"
            self.setUserDefault()
            
//            self.plans.remove(at: self.receivePlanIndex)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            let mainViewController = self.presentingViewController as? ViewController
            super.dismiss(animated: flag) {
                mainViewController?.viewWillAppear(true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func timeReminderSwitchChanged(_ sender: UISwitch) {
        if timeReminderSwitch.isOn {
            timeReminderTimeLabel.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        } else {
            timeReminderTimeLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    @IBAction func dateStartsDPicker(_ sender: Any) {
        dateFormatterr.dateStyle = DateFormatter.Style.long
        dateStartsLabel.text = dateFormatterr.string(from: dateStartsDatePicker.date)
    }
    
    @IBAction func timeReminderTPicker(_ sender: Any) {
        dateFormatterr.dateFormat="HH:mm"
        timeReminderTimeLabel.text = dateFormatterr.string(from: timeReminderTimePicker.date)
    }
    
    @IBAction func endDatesDPicker(_ sender: Any) {
        dateFormatterr.dateStyle = DateFormatter.Style.long
        dateEndsLabel.text = dateFormatterr.string(from: dateEndsDatePicker.date)
    }
    
    
    @IBAction func studyDurationTPicker(_ sender: Any) {
        lableDuration(label: studyDurationLabel, duration: Int(studyDurationTimePicker.countDownDuration))
    }
    
    @IBAction func breakDurationTPicker(_ sender: Any) {
        lableDuration(label: breakDurationLabel, duration: Int(breakDurationTimePicker.countDownDuration))
    }
    
    func setUserDefault(){
        let preStorePlans = try! NSKeyedArchiver.archivedData(withRootObject: plans, requiringSecureCoding: false)
        defaults.set(preStorePlans, forKey: "Plans")
    }
    
    //di return dalam bentuk string, selain
    func formatDateToString(date: Date, formatDate: String) -> String {
        dateFormatterr.dateFormat = formatDate
        return dateFormatterr.string(from: date)
    }
    
    func secondsToHourMinutesToSeconds (seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func lableDuration (label: UILabel, duration: Int) {
        if duration < 3600 {
            let (_, m, _) = secondsToHourMinutesToSeconds (seconds: duration)
            label.text = "\(m) minutes"
        }
        else {
            let (h, m, _) = secondsToHourMinutesToSeconds (seconds: duration)
            label.text = "\(h) hours \(m) minutes"
        }
    }
    
    func hiddenViewDatePicker(fieldName: String){
        dateStartsDatePicker.isHidden = fieldName == "dateStarts" ? !dateStartsDatePicker.isHidden : true
        dateEndsDatePicker.isHidden = fieldName == "dateEnds" ? !dateEndsDatePicker.isHidden : true
        studyDurationTimePicker.isHidden = fieldName == "studyDuration" ? !studyDurationTimePicker.isHidden : true
        breakDurationTimePicker.isHidden = fieldName == "breakDuration" ?  !breakDurationTimePicker.isHidden : true
    }
    
    func animationPicker (iP : IndexPath){
        UIView.animate(withDuration:0.3, animations: { () -> Void in
        self.tableView.beginUpdates()
        self.tableView.deselectRow(at: iP, animated: true)
        self.tableView.endUpdates()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRepeat" {
            let destination = segue.destination as! RepeatEditTableViewController
            destination.delegate = self
            destination.sendRepeatEditData = days
            return
        }
        if segue.identifier == "studyTimerSegue" {
            let destinationStudyTimer = segue.destination as! StudyTimeController
            destinationStudyTimer.receivePlanIndex = self.receivePlanIndex
        }
    }

    func repeatLabel(day: [Int]) {
        days = day
//        print(day[0])
        if day.count == 1 {
            var labelRepeat = ""
            switch day[0] {
            case 0:
                labelRepeat = "Every Monday"
            case 1:
                labelRepeat = "Every Tuesday"
            case 2:
                labelRepeat = "Every Wednesday"
            case 3:
                labelRepeat = "Every Thursday"
            case 4:
                labelRepeat = "Every Friday"
            case 5:
                labelRepeat = "Every Saturday"
            case 6:
                labelRepeat = "Every Sunday"
            default:
                break
            }
            repeatEditLabel.text = labelRepeat
            } else {
            repeatEditLabel.text = "Multiple"
            }
        
    }
    
    func receivedRepeatEditData(day: [Int]) {
        days = day
        if day.isEmpty{
            print("Kosong", day)
            self.repeatEditLabel.text = "Never"
            return
        }
        repeatLabel(day: day)
        print("Jumlah", day.count)
        
            
        }
    
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 && indexPath.row == 2 {
        let height:CGFloat = dateStartsDatePicker.isHidden ? 0.0 : 280.0
        return height
    }
    else if indexPath.section == 1 && indexPath.row == 4 {
        let height:CGFloat = dateEndsDatePicker.isHidden ? 0.0 : 280.0
        return height
    }
    else if indexPath.section == 1 && indexPath.row == 6 {
//        let height:CGFloat = timeReminderTimePicker.isHidden ? 0.0 : 58.0
        return timeReminderSwitch.isOn ? 55.0 : 0.0
    }
    else if indexPath.section == 2 && indexPath.row == 1 {
        let height:CGFloat = studyDurationTimePicker.isHidden ? 0.0 : 280.0
        return height
    }
    else if indexPath.section == 2 && indexPath.row == 3 {
        let height:CGFloat = breakDurationTimePicker.isHidden ? 0.0 : 280.0
        return height
    }
    return 66.0
  }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let startDateIndexPath = NSIndexPath (row:1, section: 1)
        let endDateIndexPath = NSIndexPath (row: 3, section: 1)
//        let timeReminderIndexPath = NSIndexPath (row:5, section: 1)
        let studyDurationIndexPath = NSIndexPath (row: 0, section: 2)
        let breakDurationIndexPath = NSIndexPath (row: 2, section: 2)
        
            
            if startDateIndexPath as IndexPath == indexPath {
                hiddenViewDatePicker(fieldName: "dateStarts")
                animationPicker(iP: indexPath)
            }
            else if endDateIndexPath as IndexPath == indexPath {
                hiddenViewDatePicker(fieldName: "dateEnds")
                animationPicker(iP: indexPath)
            }
//            else if timeReminderIndexPath as IndexPath == indexPath {
//                dateStartsDatePicker.isHidden = true
//                dateEndsDatePicker.isHidden = true
//                timeReminderTimePicker.isHidden = !timeReminderTimePicker.isHidden
//                studyDurationTimePicker.isHidden = true
//                breakDurationTimePicker.isHidden = true
//
//                animationPicker(iP: indexPath)
//            }
            else if studyDurationIndexPath as IndexPath == indexPath {
                hiddenViewDatePicker(fieldName: "studyDuration")
                animationPicker(iP: indexPath)
            }
            else if breakDurationIndexPath as IndexPath == indexPath {
                hiddenViewDatePicker(fieldName: "breakDuration")
                animationPicker(iP: indexPath)
            }
        }
        
    }


