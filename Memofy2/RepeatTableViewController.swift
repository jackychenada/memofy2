//
//  RepeatTableViewController.swift
//  Memofy2
//
//  Created by Hannatassja Hardjadinata on 07/04/21.
//

import UIKit

protocol RepeatDataDelegate: AnyObject {
    func receivedRepeatData(day: [Int])
}

class RepeatTableViewController: UITableViewController {

    weak var delegate: RepeatDataDelegate? = nil
    
    var sendRepeatData : [Int] = []
    
    var days = Set<Int>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        days = Set(sendRepeatData)
        print("Array yang keterima", sendRepeatData)
        
    }
    
    
    @IBOutlet var myTableView: UITableView!
    
    //var lastSelection: NSIndexPath!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            let myArray = Array(days).sorted()
            delegate?.receivedRepeatData(day: myArray)
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.myTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if myTableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            self.myTableView.cellForRow(at: indexPath)?.accessoryType = .none
            days.remove(indexPath.row)
            print("yg di remove", days)
        } else {
            self.myTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            days.insert(indexPath.row)
        }
        //print("Days ", days)
        self.myTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        for i in sendRepeatData {
//            self.myTableView.cellForRow(at: indexPath)?.accessoryType = indexPath.row == sendRepeatData[i] ? .checkmark : .none
//        }
//        if days.contains(indexPath.row){
//            //myTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            print("index Path", indexPath.row)
//            print("Array yg diterima", days)
//        }
        
        if let identifier = cell.reuseIdentifier {
            switch identifier {
                case "monday": cell.accessoryType = days.contains(0) ? .checkmark : .none
                case "tuesday": cell.accessoryType = days.contains(1) ? .checkmark : .none
                case "wednesday": cell.accessoryType = days.contains(2) ? .checkmark : .none
                case "thursday": cell.accessoryType = days.contains(3) ? .checkmark : .none
                case "friday": cell.accessoryType = days.contains(4) ? .checkmark : .none
                case "saturday": cell.accessoryType = days.contains(5) ? .checkmark : .none
                case "sunday": cell.accessoryType = days.contains(6) ? .checkmark : .none
                default: break
            }
        }
        
    }
    
}
