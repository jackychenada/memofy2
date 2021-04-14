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
    
    let defaults = UserDefaults.standard
    let formatDateString = "MMMM dd, yyyy"
    let formatTimeString = "HH:mm"
    let localNotification = NotificationReminder()
    let calendar = Calendar.current
    
    // model
    @IBOutlet weak var repeatTableCell: UIView!
    @IBOutlet weak var dateStartsTableCell: UIView!
    @IBOutlet weak var dateStartsDatePicker: UIDatePicker!
    @IBOutlet weak var dateEndsDatePicker: UIDatePicker!
    @IBOutlet weak var timeReminderTimePicker: UIDatePicker!
    @IBOutlet weak var timeReminderSwitch: UISwitch!
    @IBOutlet weak var studyDurationTimePicker: UIDatePicker!
    @IBOutlet weak var breakDurationTimePicker: UIDatePicker!
    @IBOutlet weak var startStudyButton: UIButton!
    // label support
    @IBOutlet weak var studyPlanTF: UITextField!
    @IBOutlet weak var studyNotesTextView: UITextView!
    @IBOutlet weak var repeatEditLabel: UILabel!
    @IBOutlet weak var dateStartsLabel: UILabel!
    @IBOutlet weak var dateEndsTableCell: UIView!
    @IBOutlet weak var dateEndsLabel: UILabel!
    @IBOutlet weak var timeReminderTableCell: UIView!
    @IBOutlet weak var timeReminderTimeLabel: UILabel!
    @IBOutlet weak var studyDurationTableCell: UIView!
    @IBOutlet weak var studyDurationLabel: UILabel!
    @IBOutlet weak var breakDurationTableCell: UIView!
    @IBOutlet weak var breakDurationLabel: UILabel!

    var choosenRepeat: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var a = "test"
        a = "belajar"
        print(a)
        
        //Ngambil data dari repeat
        timeReminderTimeLabel.text = choosenRepeat
        
        //Set default date di add
        dateStartsDatePicker.date = NSDate() as Date
        dateEndsDatePicker.date = NSDate() as Date
        timeReminderTimePicker.date = NSDate() as Date

        hiddenViewDatePicker(fieldName: "init", indexPath: [-1])

        dateFormatterr.dateStyle = DateFormatter.Style.long
        dateStartsLabel.text = formatDateToString(date: dateStartsDatePicker.date, formatDate: formatDateString)
        dateEndsLabel.text = formatDateToString(date: dateEndsDatePicker.date, formatDate: formatDateString)
        timeReminderTimeLabel.text = formatDateToString(date: timeReminderTimePicker.date, formatDate: formatTimeString)
        
        
        let tempArchiveItems = defaults.data(forKey: "Plans")
            if (tempArchiveItems != nil ) {
                plans = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tempArchiveItems!) as! [Plan]
                let plan = plans[receivePlanIndex]
                
                studyPlanTF.text = plan.studyPlan
                studyNotesTextView.text = plan.studyNotes
                receivedRepeatEditData(day: plan.frequency)
                dateStartsLabel.text = formatDateToString(date: plan.startsDate, formatDate: formatDateString)
                dateEndsLabel.text = formatDateToString(date: plan.endsDate, formatDate: formatDateString)
                timeReminderTimeLabel.text = formatDateToString(date: plan.timeReminder, formatDate: formatTimeString)
               //ini buat switch, ga perlu diconvert
                timeReminderSwitch.isOn = plan.switchReminder
                lableDuration(label: studyDurationLabel, duration: plan.studyDuration)
                lableDuration(label: breakDurationLabel, duration: plan.breakDuration)
            }
        
        let plan = plans
        if (plan[receivePlanIndex].status == "in progress") {
            startStudyButton.isEnabled = true
            startStudyButton.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            startStudyButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        } else if (plan[receivePlanIndex].status == "completed" || plan[receivePlanIndex].status == "incoming") {
            startStudyButton.isEnabled = false
            startStudyButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            startStudyButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }
        
        localNotification.listScheduledNotifications()
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
    dateStartsLabel.text = formatDateToString(date: dateStartsDatePicker.date, formatDate: formatDateString)
    }
    
    @IBAction func endDatesDPicker(_ sender: Any) {
        dateEndsLabel.text = formatDateToString(date: dateEndsDatePicker.date, formatDate: formatDateString)
    }
    
    @IBAction func timeReminderTPicker(_ sender: Any) {
        timeReminderTimeLabel.text = formatDateToString(date: timeReminderTimePicker.date, formatDate: formatTimeString)
    }
    
    @IBAction func studyDurationTPicker(_ sender: Any) {
        lableDuration(label: studyDurationLabel, duration: Int(studyDurationTimePicker.countDownDuration))
    }
    
    @IBAction func breakDurationTPicker(_ sender: Any) {
        lableDuration(label: breakDurationLabel, duration: Int(breakDurationTimePicker.countDownDuration))
    }
    
    @IBAction func saveButton(_ sender: Any) {
                 
         let plan = plans[receivePlanIndex]
         let dateNow = Date()
         var status = "in progress"
         print("start Date", dateStartsDatePicker.date)
         print("dateNow", dateNow)
         if(dateStartsDatePicker.date > dateNow) {
             status = "incoming"
         }
         if (!plan.everStudy) {
             plan.lastFinishStudy = dateStartsDatePicker.date - 3*24*60*60
             plan.everStudy = false
         }
         
        localNotification.removeWithIdentifiers(identifier: [plan.identifier])
        
        let idN = formatDateToString(date: Date(), formatDate: "yyyyMMdd'T'HHmmssSSSS")
        if !days.isEmpty{
            sendNotificationMultiple(id: idN)
        } else {
            sendNotificationSingle(id: idN)
        }
        
         plan.studyPlan = studyPlanTF.text!
         plan.studyNotes = studyNotesTextView.text
         plan.frequency = days
         plan.startsDate = dateStartsDatePicker.date
         plan.endsDate = dateEndsDatePicker.date
         plan.timeReminder = timeReminderTimePicker.date
         plan.switchReminder = timeReminderSwitch.isOn
         plan.studyDuration = Int(studyDurationTimePicker.countDownDuration)
         plan.breakDuration = Int(breakDurationTimePicker.countDownDuration)

         setUserDefault()
         
         self.dismiss(animated: true, completion: nil)

         
     }
     
     @IBAction func deletePlanButton(_ sender: Any) {

         let alert = UIAlertController(title: "Delete Plan", message: "This will delete current plan from the list", preferredStyle: UIAlertController.Style.alert)

         alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (_) in
             print("Cancel")
         }))
         alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
             let plan = self.plans[self.receivePlanIndex]
             plan.status = "removed"
             self.setUserDefault()
             self.dismiss(animated: true, completion: nil)
         }))
         self.present(alert, animated: true, completion: nil)
     }

    func setUserDefault(){
        let preStorePlans = try! NSKeyedArchiver.archivedData(withRootObject: plans, requiringSecureCoding: false)
        defaults.set(preStorePlans, forKey: "Plans")
    }
    
    //di return dalam bentuk string, selain itu jadi date
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
    
    func hiddenViewDatePicker(fieldName: String, indexPath: IndexPath){
        dateStartsDatePicker.isHidden = fieldName == "dateStarts" ? !dateStartsDatePicker.isHidden : true
        dateEndsDatePicker.isHidden = fieldName == "dateEnds" ? !dateEndsDatePicker.isHidden : true
        studyDurationTimePicker.isHidden = fieldName == "studyDuration" ? !studyDurationTimePicker.isHidden : true
        breakDurationTimePicker.isHidden = fieldName == "breakDuration" ?  !breakDurationTimePicker.isHidden : true
        
        animationPicker(iP: indexPath)
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

    func receivedRepeatEditData(day: [Int]) {
        days = day
        if day.isEmpty{
            self.repeatEditLabel.text = "Never"
            return
        }
        let dayNames = ["Every Sunday", "Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday"]
        if (day.count == 1) {
            return repeatEditLabel.text = dayNames[day[0]-1]
        }
        else {
            repeatEditLabel.text = "Multiple"
        }
        }
    
    func sendNotificationMultiple(id: String) {
            let rangeDate = calendar.dateComponents([.day], from: dateStartsDatePicker.date, to: dateEndsDatePicker.date)
            
            var tempDate = dateStartsDatePicker.date
            var weekday = -1
            print("range yang dibuat adalah", rangeDate.day!)
            var indexIndetifier = 0
            let timeNotification = calendar.dateComponents([.hour, .minute], from: timeReminderTimePicker.date)
            for _ in 0..<rangeDate.day! {
                weekday = Calendar.current.component(.weekday, from: tempDate)
                
                print("tempDatenya adalah", tempDate)
                let dateNotification = calendar.dateComponents([.year, .month, .day], from: tempDate)
                
                let getIndex = (days.firstIndex(of: weekday) != nil ? days.firstIndex(of: weekday) : -1)!
                if(getIndex > -1) {
                    //schedule here
                    localNotification.notifications.append(
                        Notification(
                            id: "\(id)-\(indexIndetifier)",
                            title: studyPlanTF.text ?? "none",
                            datetime:DateComponents(calendar: Calendar.current, year: dateNotification.year, month: dateNotification.month, day: dateNotification.day, hour: timeNotification.hour, minute: timeNotification.minute),
                            body: "Hey, your study time is available now!")
                        )
                    indexIndetifier += 1
                }
                tempDate += (1*24*60*60)
                print("weekday", weekday)
            }

            localNotification.schedule()
            localNotification.listScheduledNotifications()
        }
    
    func sendNotificationSingle(id: String) {
            let dateNotification = calendar.dateComponents([.year, .month, .day], from: dateStartsDatePicker.date)
            
            let timeNotification = calendar.dateComponents([.hour, .minute], from: timeReminderTimePicker.date)
            localNotification.notifications.append(
                Notification(
                    id: "\(id)",
                    title: studyPlanTF.text ?? "none",
                    datetime:DateComponents(calendar: Calendar.current, year: dateNotification.year, month: dateNotification.month, day: dateNotification.day, hour: timeNotification.hour, minute: timeNotification.minute), body: "Hey, your study time is available now!")
                )
            localNotification.schedule()
            localNotification.listScheduledNotifications()
        }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        let mainViewController = self.presentingViewController as? ViewController
        super.dismiss(animated: flag) {
            mainViewController?.viewWillAppear(true)
        }
    }
    
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let isCellDateStarts = indexPath.section == 1 && indexPath.row == 2
    let isCelDateEnds = indexPath.section == 1 && indexPath.row == 4
    let isTimeReminderSwitch = indexPath.section == 1 && indexPath.row == 6
    let isStudyDurationTimePicker = indexPath.section == 2 && indexPath.row == 1
    let isBreakDurationTimePicker = indexPath.section == 2 && indexPath.row == 3
    
    var tempHeight:CGFloat = 66.0
    
    if (isCellDateStarts && dateStartsDatePicker.isHidden) || (isCelDateEnds && dateEndsDatePicker.isHidden) || (isTimeReminderSwitch && !timeReminderSwitch.isOn) || (isStudyDurationTimePicker && studyDurationTimePicker.isHidden) || (isBreakDurationTimePicker && breakDurationTimePicker.isHidden) {
        tempHeight = 0.0
    }
    if (isCellDateStarts && !dateStartsDatePicker.isHidden) || (isCelDateEnds && !dateEndsDatePicker.isHidden) {
        tempHeight = 290.0
    }
    if (isTimeReminderSwitch && timeReminderSwitch.isOn) {
        tempHeight = 55.0
    }
    if (isStudyDurationTimePicker && !studyDurationTimePicker.isHidden) || (isBreakDurationTimePicker && !breakDurationTimePicker.isHidden) {
        tempHeight = 162.0
    }
    return tempHeight
  }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let startDateIndexPath = NSIndexPath (row:1, section: 1)
        let endDateIndexPath = NSIndexPath (row: 3, section: 1)
        let studyDurationIndexPath = NSIndexPath (row: 0, section: 2)
        let breakDurationIndexPath = NSIndexPath (row: 2, section: 2)
        
        if startDateIndexPath as IndexPath == indexPath {
            hiddenViewDatePicker(fieldName: "dateStarts", indexPath: indexPath)
        } else if endDateIndexPath as IndexPath == indexPath {
            hiddenViewDatePicker(fieldName: "dateEnds", indexPath: indexPath)
        } else if studyDurationIndexPath as IndexPath == indexPath {
            hiddenViewDatePicker(fieldName: "studyDuration", indexPath: indexPath)
        } else if breakDurationIndexPath as IndexPath == indexPath {
            hiddenViewDatePicker(fieldName: "breakDuration", indexPath: indexPath)
        }
    }
}


