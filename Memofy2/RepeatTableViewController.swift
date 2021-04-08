//
//  RepeatTableViewController.swift
//  Memofy2
//
//  Created by Hannatassja Hardjadinata on 07/04/21.
//

import UIKit

protocol RepeatDataDelegate: AnyObject {
    func receivedRepeatData(info: String)
}

class RepeatTableViewController: UITableViewController {

    weak var delegate: RepeatDataDelegate? = nil
    
    var sendRepeatData = ""
    
    var days = Set<Int>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sendRepeatData)

    }
    
    
    @IBOutlet var myTableView: UITableView!
    
    //var lastSelection: NSIndexPath!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            let myArray = Array(days).sorted()
            //print(myArray.sorted())
            delegate?.receivedRepeatData(info: "GUA MAU XX")
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.myTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if myTableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            self.myTableView.cellForRow(at: indexPath)?.accessoryType = .none
            days.remove(indexPath.row)
        } else {
            self.myTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            days.insert(indexPath.row)
        }
        print("Days ", days)
        self.myTableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        self.myTableView.cellForRow(at: indexPath)?.accessoryType = .none
//    }


    
    
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

}
