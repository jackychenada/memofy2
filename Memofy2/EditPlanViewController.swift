//
//  EditPlanViewController.swift
//  Memofy2
//
//  Created by Adinda Puji Rahmawaty on 04/04/21.
//

import UIKit

class EditPlanViewController: UITableViewController, RepeatEditDataDelegate {
    
    var dateFormatterr = DateFormatter()
    
    var plans : [Plan] = []
    var days : [Int] = []
    
    let planDummy = "Programming"
    let noteDummy = "Swift Playground"
    let statusDummy = "Completed"
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
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
        
        //Ngambil data dari repeat
        timeReminderTimeLabel.text = choosenRepeat
        
        //Set default date di add
        dateStartsDatePicker.date = NSDate() as Date
        dateEndsDatePicker.date = NSDate() as Date
        timeReminderTimePicker.date = NSDate() as Date
        
        hiddenViewDatePicker(fieldName: "init")
        
        dateFormatterr.dateStyle = DateFormatter.Style.long
        
        dateStartsLabel.text = dateFormatterr.string(from: dateStartsDatePicker.date)
        
        dateEndsLabel.text = dateFormatterr.string(from: dateEndsDatePicker.date)
        
        dateFormatterr.dateFormat = "HH:mm"
        timeReminderTimeLabel.text = dateFormatterr.string(from: timeReminderTimePicker.date)
        
        if (statusDummy == "Completed") {
            startStudyButton.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            startStudyButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        } else if (statusDummy == "To Do") {
            startStudyButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            startStudyButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }
    }
    
    @IBAction func deletePlanButton(_ sender: Any) {
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

        }
    }
    
    func receivedRepeatEditData(day: [Int]) {
        days = day
        
        if !day.isEmpty {
            print("Jumlah", day.count)
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
            } else {
                print("Kosong", day)
                self.repeatEditLabel.text = "Never"
            }
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


