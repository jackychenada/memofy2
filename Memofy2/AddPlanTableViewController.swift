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
    
    @IBOutlet weak var studyPlanTextField: UITextField!
    @IBOutlet weak var studyNotesTextView: UITextView!
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var startsDatePicker: UIDatePicker!
    @IBOutlet weak var endsDatePicker: UIDatePicker!
    @IBOutlet weak var timeReminderPicker: UIDatePicker!
    
    @IBOutlet weak var switchReminder: UISwitch!
    
    @IBOutlet weak var startsDateLabel: UILabel!
    @IBOutlet weak var endsDateLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    
    @IBOutlet weak var studyDurationPicker: UIDatePicker!
    @IBOutlet weak var breakDurationPicker: UIDatePicker!
    
    @IBOutlet weak var studyDurationLabel: UILabel!
    @IBOutlet weak var breakDurationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SET DEFAULT DATE DI ADD
        startsDatePicker.date = NSDate() as Date
        endsDatePicker.date = NSDate() as Date
        timeReminderPicker.date = NSDate() as Date
        
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        startsDateLabel.text = dateFormatter.string(from: startsDatePicker.date)
        endsDateLabel.text = dateFormatter.string(from: endsDatePicker.date)
        
        dateFormatter.dateFormat="HH:mm"
        reminderLabel.text = dateFormatter.string(from: timeReminderPicker.date)
        
        
//        timeReminderPicker.isHidden = true
//        switchReminder.isOn = false
        
        hiddenViewDatePicker(fieldName: "init")
        
        studyDurationPicker.countDownDuration = 3600
        breakDurationPicker.countDownDuration = 600
        
        //USER DEFAULT GETTER
        //Mencari user default dengan key plans
//        defaults.removeObject(forKey: "Plans")
        let tempArchiveItems = defaults.data(forKey: "Plans")

        //cek tempArchiveItemsnya ada default dengan key plans atau tidak
        print("tempArchiveItems ", tempArchiveItems as Any)
        
        print("ALL USER DEFAULT", UserDefaults.standard.dictionaryRepresentation())

        if (tempArchiveItems != nil) {

            //Kalo tidak kosong, bisa kebuka default dengan key plans dan datanya
            plans = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(tempArchiveItems!) as! [Plan]
            print("Check Plans : ", plans)
            print("Mo cek array index", plans[0].status)
        }
        
    }
    
    @IBAction func startsDP(_ sender: Any) {
        dateFormatter.dateStyle = DateFormatter.Style.long
        startsDateLabel.text = dateFormatter.string(from : startsDatePicker.date)
    }
    
    @IBAction func endsDP(_ sender: Any) {
        dateFormatter.dateStyle = DateFormatter.Style.long
        endsDateLabel.text = dateFormatter.string(from: endsDatePicker.date)
    }
    
    @IBAction func switchOn(_ sender: Any) {
//        timeReminderPicker.isHidden = !timeReminderPicker.isHidden
//        print("switch :", switchReminder.isOn)
//        print("time reminder :", timeReminderPicker.isHidden)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func reminderDP(_ sender: Any) {
        dateFormatter.dateFormat="HH:mm"
        reminderLabel.text = dateFormatter.string(from: timeReminderPicker.date)
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
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            let mainViewController = self.presentingViewController as? ViewController
            super.dismiss(animated: flag) {
                mainViewController?.viewWillAppear(true)
        }
    }
    
    @IBAction func addData(_ sender: Any) {
        print("before", plans)
        
        //let test : [Int] = [1,2]
        //Ini Buat Tambah Data
//        self.addPlan(
//            index: plans.count,
//            studyPlan: studyPlanTextField.text ?? "test",
//            studyNotes: studyNotesTextView.text,
//            frequency: test,
//            startsDate: startsDatePicker.date,
//            endsDate: endsDatePicker.date,
//            timeReminder: timeReminderPicker.date,
//            switchReminder: switchReminder.isOn,
//            studyDuration: Int(studyDurationPicker.countDownDuration),
//            breakDuration: Int(breakDurationPicker.countDownDuration))
        
        
        plans.append(
            Plan(
                index: plans.count,
                status: "in progress",
                studyPlan: studyPlanTextField.text ?? "test",
                studyNotes: studyNotesTextView.text,
                frequency: days,
                startsDate: startsDatePicker.date,
                endsDate: endsDatePicker.date,
                timeReminder: timeReminderPicker.date,
                switchReminder: switchReminder.isOn,
                studyDuration: Int(studyDurationPicker.countDownDuration),
                breakDuration: Int(breakDurationPicker.countDownDuration)))

        print("Cek data array plans", plans[0].index)
        print("cek data array plans", plans[0].status)
       print("Cek data array plans", plans[0].studyPlan)
       print("Cek data array plans", plans[0].studyNotes)
       print("Cek data array plans", plans[0].frequency)
       print("Cek data array plans", plans[0].startsDate)
       print("Cek data array plans", plans[0].endsDate)
       print("Cek data array plans", plans[0].timeReminder)
       print("Cek data array plans", plans[0].switchReminder)
       print("Cek data array plans", plans[0].studyDuration)
       print("Cek data array plans", plans[0].breakDuration)
        let preStoreTasks = try! NSKeyedArchiver.archivedData(withRootObject: plans, requiringSecureCoding: false)
        
        
        print("INI DATA JADI BYTE", preStoreTasks)
        
        //MASUKKIN KE USER DEFAULT
        defaults.set(preStoreTasks, forKey: "Plans")

        //Untuk nge cek persatuan
        print("Satu-satu", defaults.object(forKey: "Plans") as Any )
        
        //Cek keseluruhan
        print("ALL USER DEFAULT", UserDefaults.standard.dictionaryRepresentation())
        
        print("addData plans : ", plans)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func labelDuration (label : UILabel, duration : Int) {
        if duration < 3600 {
            let (_, m, _) = secondsToHoursMinutesSeconds(seconds: duration)
            label.text = "\(m) minutes"
        } else {
            let (h, m, _) = secondsToHoursMinutesSeconds(seconds: duration)
            label.text = "\(h) hours \(m) minutes"
        }
    }
    
    func hiddenViewDatePicker(fieldName : String){
        startsDatePicker.isHidden = fieldName == "startsDate" ? !startsDatePicker.isHidden : true
        endsDatePicker.isHidden = fieldName == "endsDate" ? !endsDatePicker.isHidden : true
        studyDurationPicker.isHidden = fieldName == "studyDuration" ? !studyDurationPicker.isHidden : true
        breakDurationPicker.isHidden = fieldName == "breakDuration" ? !breakDurationPicker.isHidden : true
    }
    
    func animateDatePickerView(iP : IndexPath){
        UIView.animate(withDuration:0.3, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: iP, animated: true)
            self.tableView.endUpdates()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRepeat" {
            let secondViewController = segue.destination as! RepeatTableViewController
            secondViewController.delegate = self
            secondViewController.sendRepeatData = days
        }
    }
    
    func receivedRepeatData(day: [Int]) {
        days = day
        if !day.isEmpty {
            print("Jumlah", day.count)
            if day.count == 1{
                var labelRepeat = ""
                switch day[0] {
                case 0 :
                    labelRepeat = "Every Monday"
                case 1 :
                    labelRepeat = "Every Tuesday"
                case 2 :
                    labelRepeat = "Every Wednesday"
                case 3 :
                    labelRepeat = "Every Thursday"
                case 4 :
                    labelRepeat = "Every Friday"
                case 5 :
                    labelRepeat = "Every Saturday"
                case 6 :
                    labelRepeat = "Every Sunday"
                default:
                    break
                }
                repeatLabel.text = labelRepeat
            } else {
                repeatLabel.text = "Multiple"
            }
        } else {
            print("Array Kosong", day)
            repeatLabel.text = "Never"
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            let height:CGFloat = startsDatePicker.isHidden ? 0.0 : 290.0
               return height
        } else if indexPath.section == 1 && indexPath.row == 4 {
            let height:CGFloat = endsDatePicker.isHidden ? 0.0 : 290.0
               return height
        } else if indexPath.section ==  1 && indexPath.row == 6 {
//            let height:CGFloat = timeReminderPicker.isHidden ? 0.0 : 55.0
//               return height
            return switchReminder.isOn ? 55.0 : 0.0
        } else if indexPath.section == 2 && indexPath.row == 1 {
            let height:CGFloat = studyDurationPicker.isHidden ? 0.0 : 162.0
               return height
        } else if indexPath.section == 2 && indexPath.row == 3 {
            let height:CGFloat = breakDurationPicker.isHidden ? 0.0 : 162.0
               return height
        }
//           return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        return 66.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let startsIndexPath = NSIndexPath(row: 1, section: 1)
        let endsIndexPath = NSIndexPath(row: 3, section: 1)
        let studyIndexPath = NSIndexPath(row: 0, section: 2)
        let breakIndexPath = NSIndexPath(row: 2, section: 2)
        
        if startsIndexPath as IndexPath == indexPath {

            hiddenViewDatePicker(fieldName: "startsDate")
            animateDatePickerView(iP: indexPath)

        } else if endsIndexPath as IndexPath == indexPath {
            
            hiddenViewDatePicker(fieldName: "endsDate")
            animateDatePickerView(iP: indexPath)
            
        } else if studyIndexPath as IndexPath == indexPath {
            
            hiddenViewDatePicker(fieldName: "studyDuration")
            animateDatePickerView(iP: indexPath)
            
        } else if breakIndexPath as IndexPath == indexPath {
            
            hiddenViewDatePicker(fieldName: "breakDuration")
            animateDatePickerView(iP: indexPath)
            
        }
    }

}
