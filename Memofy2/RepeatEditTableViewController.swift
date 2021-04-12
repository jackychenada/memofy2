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
    
//    var repeatDataEdit: String!
    
    weak var delegate: RepeatEditDataDelegate? = nil
    
    var sendRepeatEditData : [Int] = []
    
    var days = Set<Int>()

    
    @IBOutlet var repeatEditTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        days = Set(sendRepeatEditData)
        print("Ini adalah Array", sendRepeatEditData)
        print("Ini days ke ", days)
        
    }
    
    // lol, bukan ketik sendiri, tapi pake "viewWillDissapear
//    override func backToEdit(_ animated:Bool) {
//    super.backToEdit (animated)
//
//        if self.isMovingFromParent {
//            let myArray = Array(days).sorted()
//            delegate?.receivedRepeatEditData(day: myArray)
//        }
//    }
    
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
        days.remove(indexPath.row)
        }
        else {
            self.repeatEditTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            days.insert(indexPath.row)
        }
        self.repeatEditTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("Gw di sini")
        if let identifier =  cell.reuseIdentifier
        {
//        print("I am in")
//        print(identifier)
        switch identifier {
            case "monday":
                cell.accessoryType = days.contains(0) ? .checkmark : .none
            case "tuesday": cell.accessoryType = days.contains(1) ? .checkmark : .none
            case "wednesday": cell.accessoryType = days.contains(2) ? .checkmark : .none
            case "thursday": cell.accessoryType = days.contains(3) ? .checkmark : .none
            case "friday": cell.accessoryType = days.contains(4) ? .checkmark : .none
            case "satuday": cell.accessoryType = days.contains(5) ? .checkmark : .none
            case "sunday": cell.accessoryType = days.contains(6) ? .checkmark : .none
            default: break
            }
        }
    }
}
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
