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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            let myArray = Array(days).sorted()
            delegate?.receivedRepeatData(day: myArray)
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.myTableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            self.myTableView.cellForRow(at: indexPath)?.accessoryType = .none
            days.remove(indexPath.row)
            print("yg di remove", days)
        } else {
            self.myTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            days.insert(indexPath.row)
        }

        self.myTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = days.contains(indexPath.row) ? .checkmark : .none
    
    }
    
}
