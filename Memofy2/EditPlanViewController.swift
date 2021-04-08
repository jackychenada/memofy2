//
//  EditPlanViewController.swift
//  Memofy2
//
//  Created by Adinda Puji Rahmawaty on 04/04/21.
//

import UIKit

class EditPlanViewController: UITableViewController {
    
    var dateFormatterr = DateFormatter()
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var repeatTableCell: UIView!
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set default date di add
        dateStartsDatePicker.date = NSDate() as Date
        dateEndsDatePicker.date = NSDate() as Date
        
        dateFormatterr.dateStyle = DateFormatter.Style.long
        
        dateStartsLabel.text = dateFormatterr.string(from: dateStartsDatePicker.date)
        
        dateEndsLabel.text = dateFormatterr.string(from: dateEndsDatePicker.date)
        
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
    
    @IBAction func endDatesDPicker(_ sender: Any) {
        dateFormatterr.dateStyle = DateFormatter.Style.long
        dateEndsLabel.text = dateFormatterr.string(from: dateEndsDatePicker.date)
    }
    
    
    @IBAction func studyDurationTPicker(_ sender: Any) {
        let duration : Int = Int (studyDurationTimePicker.countDownDuration)
        if duration < 3600 {
            let (_, m, _) = secondsToHourMinutesToSeconds (seconds: duration)
            studyDurationLabel.text = "\(m) minutes"
        }
    }
    
    @IBAction func breakDurationTPicker(_ sender: Any) {
        let duration : Int = Int (breakDurationTimePicker.countDownDuration)
        if duration < 3600 {
            let (_, m, _) = secondsToHourMinutesToSeconds (seconds: duration)
            breakDurationLabel.text = "\(m) minutes"
        }
    }
    
    
    func secondsToHourMinutesToSeconds (seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func hiddenViewDatePicker(fieldName: String){
        dateStartsDatePicker.isHidden = fieldName == "dateStarts" ? false : true
        dateEndsDatePicker.isHidden = fieldName == "dateEnds" ? false : true
        studyDurationTimePicker.isHidden = fieldName == "studyDuration" ? false : true
        breakDurationTimePicker.isHidden = fieldName == "breakDuration" ?  false : true
    }
    
    func animationPicker (iP : IndexPath){
        UIView.animate(withDuration:0.3, animations: { () -> Void in
        self.tableView.beginUpdates()
        self.tableView.deselectRow(at: iP, animated: true)
        self.tableView.endUpdates()
        })
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
        let height:CGFloat = timeReminderTimePicker.isHidden ? 0.0 : 58.0
        return height
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
        let timeReminderIndexPath = NSIndexPath (row:5, section: 1)
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
            else if timeReminderIndexPath as IndexPath == indexPath {
                dateStartsDatePicker.isHidden = true
                dateEndsDatePicker.isHidden = true
                timeReminderTimePicker.isHidden = !timeReminderTimePicker.isHidden
                studyDurationTimePicker.isHidden = true
                breakDurationTimePicker.isHidden = true
                
                animationPicker(iP: indexPath)
            }
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


