//
//  RepeatDetails.swift
//  Memofy2
//
//  Created by Adinda Puji Rahmawaty on 08/04/21.
//

import UIKit

protocol repeatDataDeligate: AnyObject {
    func receiveRepeatDetails (info: String)
}

class repeatDetails: UITableViewController{
    
    weak var delegate: repeatDataDeligate? = nil
    
    var sendRepeatDetails = ""
    
    var days = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sendRepeatDetails)
    }
    
    func viewWillDissapear (_ animated: Bool) {
    super.viewWillDisappear(animated)

    if self.isMovingFromParent {
    _ = Array(days).sorted()
    delegate?.receiveRepeatDetails(info: "I have no idea")
        }
    }
    
    @IBOutlet var repeatDetailTable: UITableView!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if repeatDetailTable.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            self.repeatDetailTable.cellForRow(at: indexPath)?.accessoryType = .none
            days.remove(indexPath.row)
        } else {
            self.repeatDetailTable.cellForRow(at: indexPath)?.accessoryType = .checkmark
            days.insert(indexPath.row)
        }
        print("Days", days)
        self.repeatDetailTable.deselectRow(at: indexPath, animated: true)
    }
    
    
}

