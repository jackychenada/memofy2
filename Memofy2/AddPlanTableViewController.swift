//
//  AddPlanTableViewController.swift
//  Memofy2
//
//  Created by Hannatassja Hardjadinata on 05/04/21.
//

import UIKit


class AddPlanTableViewController: UITableViewController, RepeatDataDelegate {
     
    var plans : [Plan] = []
    var days : [Int] = []
    
    let dateFormatter = DateFormatter()
    let defaults = UserDefaults.standard
    let localNotification = NotificationReminder()
    let calendar = Calendar.current
    
    let formatDateString = "MMMM dd, yyyy"
    let formatTimeString = "HH:mm"
    //model
    @IBOutlet weak var studyPlanTextField: UITextField!
    @IBOutlet weak var studyNotesTextView: UITextView!
    @IBOutlet weak var startsDatePicker: UIDatePicker!
    @IBOutlet weak var endsDatePicker: UIDatePicker!
    @IBOutlet weak var timeReminderPicker: UIDatePicker!
    @IBOutlet weak var switchReminder: UISwitch!
    @IBOutlet weak var studyDurationPicker: UIDatePicker!
    @IBOutlet weak var breakDurationPicker: UIDatePicker!
    //label support
    @IBOutlet weak var studyDurationLabel: UILabel!
    @IBOutlet weak var breakDurationLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var startsDateLabel: UILabel!
    @IBOutlet weak var endsDateLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SET DEFAULT DATE DI ADD
        startsDatePicker.date = NSDate() as Date
        endsDatePicker.date = NSDate() as Date
        timeReminderPicker.date = NSDate() as Date
        
        startsDateLabel.text = formatDateToString(date: startsDatePicker.date, formatDate: formatDateString)
        endsDateLabel.text = formatDateToString(date: endsDatePicker.date, formatDate: formatDateString)
        
        reminderLabel.text = formatDateToString(date: timeReminderPicker.date, formatDate: formatTimeString)
        
        hiddenViewDatePicker(fieldName: "init", indexPath: [-1])
        
        studyDurationPicker.countDownDuration = 3600
        breakDurationPicker.countDownDuration = 600
        
        //defaults.removeObject(forKey: "Plans")
        getUserDefault()

        //localNotification.removeAllNotification()
        localNotification.listScheduledNotifications()
    }
    
    @IBAction func startsDP(_ sender: Any) {
        startsDateLabel.text = formatDateToString(date: startsDatePicker.date, formatDate: formatDateString)
    }
    
    @IBAction func endsDP(_ sender: Any) {
        endsDateLabel.text = formatDateToString(date: endsDatePicker.date, formatDate: formatDateString)
    }
    
    @IBAction func switchOn(_ sender: Any) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func reminderDP(_ sender: Any) {
        reminderLabel.text = formatDateToString(date: timeReminderPicker.date, formatDate: formatTimeString)
    }
    
    @IBAction func studyDurationDP(_ sender: Any) {
        labelDuration(label: studyDurationLabel, duration: Int(studyDurationPicker.countDownDuration))
    }
    
    @IBAction func breakDurationDP(_ sender: Any) {
        labelDuration(label: breakDurationLabel, duration: Int(breakDurationPicker.countDownDuration))
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addData(_ sender: Any) {

        let dateNow = Date()
        var status = "in progress"
        print("start Date", startsDatePicker.date)
        print("dateNow", dateNow)
        if(startsDatePicker.date > dateNow) {
            status = "incoming"
        }

        let id = formatDateToString(date: Date(), formatDate: "yyyyMMdd'T'HHmmssSSSS")
        if !days.isEmpty {
            sendNotificationMultiple(id: id)
        } else {
            sendNotificationSingle(id: id)
        }

        plans.append(
            Plan(
                index: plans.count,
                status: status,
                studyPlan: studyPlanTextField.text ?? "test",
                studyNotes: studyNotesTextView.text,
                frequency: days,
                startsDate: startsDatePicker.date,
                endsDate: endsDatePicker.date,
                timeReminder: timeReminderPicker.date,
                switchReminder: switchReminder.isOn,
                studyDuration: Int(studyDurationPicker.countDownDuration),
                breakDuration: Int(breakDurationPicker.countDownDuration),
                lastFinishStudy: startsDatePicker.date - 3*24*60*60,
                everStudy: false,
                identifier: "\(id)")
            )

//        print("Cek data array plans", plans[0].index)
//        print("cek data array plans", plans[0].status)
//       print("Cek data array plans", plans[0].studyPlan)
//       print("Cek data array plans", plans[0].studyNotes)
//       print("Cek data array plans", plans[0].frequency)
//       print("Cek data array plans", plans[0].startsDate)
//       print("Cek data array plans", plans[0].endsDate)
//       print("Cek data array plans", plans[0].timeReminder)
//       print("Cek data array plans", plans[0].switchReminder)
//       print("Cek data array plans", plans[0].studyDuration)
//       print("Cek data array plans", plans[0].breakDuration)
        //print("cek data array plans", startsDatePicker.date-3*24*60*60)

        let preStorePlans = try! NSKeyedArchiver.archivedData(withRootObject: plans, requiringSecureCoding: false)
        //print("INI DATA JADI BYTE", preStorePlans)
        
        //MASUKKIN KE USER DEFAULT
        defaults.set(preStorePlans, forKey: "Plans")

        //Untuk nge cek persatuan
        //print("Satu-satu", defaults.object(forKey: "Plans") as Any )
        
        //Cek keseluruhan
        //print("ALL USER DEFAULT", UserDefaults.standard.dictionaryRepresentation())
        
        //print("addData plans : ", plans)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendNotificationMultiple(id: String) {
        let rangeDate = calendar.dateComponents([.day], from: startsDatePicker.date, to: endsDatePicker.date)
        
        var tempDate = startsDatePicker.date
        var weekday = -1
        print("range", rangeDate.day!)
        var indexIndetifier = 0
        let timeNotification = calendar.dateComponents([.hour, .minute], from: timeReminderPicker.date)
        for _ in 0..<rangeDate.day! {
            //print("i", i)
            weekday = Calendar.current.component(.weekday, from: tempDate)
            //print("weekday", weekday)
            
            print("tempDate", tempDate)
            let dateNotification = calendar.dateComponents([.year, .month, .day], from: tempDate)
            
            let getIndex = (days.firstIndex(of: weekday) != nil ? days.firstIndex(of: weekday) : -1)!
            if(getIndex > -1) {
                //schedule here
                localNotification.notifications.append(
                    Notification(
                        id: "\(id)-\(indexIndetifier)",
                        title: studyPlanTextField.text ?? "none",
                        datetime:DateComponents(calendar: Calendar.current, year: dateNotification.year, month: dateNotification.month, day: dateNotification.day, hour: timeNotification.hour, minute: timeNotification.minute))
                    )
                indexIndetifier += 1
                print("is here dudde")
            }
            tempDate += (1*24*60*60)

            print("weekday", weekday)
        }

        localNotification.schedule()
        localNotification.listScheduledNotifications()
    }
    
    func sendNotificationSingle(id: String) {
        let dateNotification = calendar.dateComponents([.year, .month, .day], from: startsDatePicker.date)
        
        let timeNotification = calendar.dateComponents([.hour, .minute], from: timeReminderPicker.date)
        localNotification.notifications.append(
            Notification(
                id: "\(id)",
                title: studyPlanTextField.text ?? "none",
                datetime:DateComponents(calendar: Calendar.current, year: dateNotification.year, month: dateNotification.month, day: dateNotification.day, hour: timeNotification.hour, minute: timeNotification.minute))
            )
        localNotification.schedule()
        localNotification.listScheduledNotifications()
    }

    func getUserDefault(){
        let tempArchiveItems = defaults.data(forKey: "Plans")
        //print("tempArchiveItems ", tempArchiveItems as Any)
        if(tempArchiveItems != nil){
            plans = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tempArchiveItems!) as! [Plan]
        }
    }
    
    
    func formatDateToString(date: Date, formatDate: String) -> String {
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func labelDuration (label : UILabel, duration : Int) {
        let (h, m, _) = secondsToHoursMinutesSeconds(seconds: duration)
        label.text = duration < 3600 ? "\(m) minutes" : "\(h) hours \(m) minutes"
    }
    
    func hiddenViewDatePicker(fieldName : String, indexPath: IndexPath){
        startsDatePicker.isHidden = fieldName == "startsDate" ? !startsDatePicker.isHidden : true
        endsDatePicker.isHidden = fieldName == "endsDate" ? !endsDatePicker.isHidden : true
        studyDurationPicker.isHidden = fieldName == "studyDuration" ? !studyDurationPicker.isHidden : true
        breakDurationPicker.isHidden = fieldName == "breakDuration" ? !breakDurationPicker.isHidden : true
        
        animateDatePickerView(iP: indexPath)
    }
    
    func animateDatePickerView(iP : IndexPath){
        UIView.animate(withDuration:0.3, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: iP, animated: true)
            self.tableView.endUpdates()
        })
    }
    
    func receivedRepeatData(day: [Int]) {
        days = day
        if(day.isEmpty){
            return repeatLabel.text = "Never"
        }
        let dayNames = ["Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday", "Every Sunday"]
        if(day.count == 1) {
            return repeatLabel.text = dayNames[day[0]]
        }else{
            repeatLabel.text = "Multiple"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRepeat" {
            let secondViewController = segue.destination as! RepeatTableViewController
            secondViewController.delegate = self
            secondViewController.sendRepeatData = days
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            let mainViewController = self.presentingViewController as? ViewController
            super.dismiss(animated: flag) {
                mainViewController?.viewWillAppear(true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isCellStartDate = indexPath.section == 1 && indexPath.row == 2
        let isCellEndDate = indexPath.section == 1 && indexPath.row == 4
        let isCellReminder = indexPath.section ==  1 && indexPath.row == 6
        let isCellStudyDuration = indexPath.section == 2 && indexPath.row == 1
        let isCellBreakDuration = indexPath.section == 2 && indexPath.row == 3
        
        var tempHeight:CGFloat = 66.0
        
        if(isCellStartDate && startsDatePicker.isHidden) || (isCellEndDate && endsDatePicker.isHidden) || (isCellReminder && !switchReminder.isOn) || (isCellStudyDuration && studyDurationPicker.isHidden) || (isCellBreakDuration && breakDurationPicker.isHidden) {
            tempHeight = 0.0
        }
        
        if(isCellStartDate && !startsDatePicker.isHidden) || (isCellEndDate && !endsDatePicker.isHidden){
            tempHeight = 290.0
        }
        
        if(isCellReminder && switchReminder.isOn) {
            tempHeight = 55.0
        }
        
        if((isCellStudyDuration && !studyDurationPicker.isHidden) || (isCellBreakDuration && !breakDurationPicker.isHidden)) {
            tempHeight = 162.0
        }
        return tempHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let startsIndexPath = NSIndexPath(row: 1, section: 1)
        let endsIndexPath = NSIndexPath(row: 3, section: 1)
        let studyIndexPath = NSIndexPath(row: 0, section: 2)
        let breakIndexPath = NSIndexPath(row: 2, section: 2)
        
        if startsIndexPath as IndexPath == indexPath {
            hiddenViewDatePicker(fieldName: "startsDate", indexPath: indexPath)
        } else if endsIndexPath as IndexPath == indexPath {
            hiddenViewDatePicker(fieldName: "endsDate", indexPath: indexPath)
        } else if studyIndexPath as IndexPath == indexPath {
            hiddenViewDatePicker(fieldName: "studyDuration", indexPath: indexPath)
        } else if breakIndexPath as IndexPath == indexPath {
            hiddenViewDatePicker(fieldName: "breakDuration", indexPath: indexPath)
        }
    }

}
