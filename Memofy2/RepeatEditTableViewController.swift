//
//  RepeatEditTableViewController.swift
//  Memofy2
//
//  Created by Adinda Puji Rahmawaty on 09/04/21.
//

import UIKit

protocol RepeatEditDataDelegate: AnyObject {
    func receivedRepeatEditData(day : [Int])
}

class RepeatEditTableViewController: UITableViewController {
    
    weak var delegate: RepeatEditDataDelegate? = nil
    
    var sendRepeatEditData : [Int] = []
    var days = Set<Int>()
    
    @IBOutlet var repeatEditTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        days = Set(sendRepeatEditData)
//        print("Ini adalah Array", sendRepeatEditData)
//        print("Ini days ke ", days)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            let myArray = Array(days).sorted()
            delegate?.receivedRepeatEditData(day: myArray)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if repeatEditTableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            self.repeatEditTableView.cellForRow(at: indexPath)?.accessoryType = .none
        days.remove(indexPath.row+1)
        }
        else {
            self.repeatEditTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            days.insert(indexPath.row+1)
        }
        self.repeatEditTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = days.contains(indexPath.row+1) ? .checkmark : .none
    }
}
