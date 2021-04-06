//
//  ViewController.swift
//  Memofy2
//
//  Created by JACKY on 23/03/21.
//

import UIKit

class StudyTimeController: UIViewController {
    
      @IBOutlet weak var timerLabel: UILabel!
      @IBOutlet weak var playButton: UIButton!
//
    @IBOutlet weak var stopButton: UIButton!
    
    var timer:Timer = Timer()
    var count:Int = 3602
    var isCountTimer:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.setTitle("START", for: .normal)
        timerLabel.text = setTimerTextLabel()
    }
    
    @IBAction func stopButtonTap(_ sender: Any){
        let alert = UIAlertController(title: "done?", message: "yakin bro?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (_) in
            print("cancel")
        }))
        alert.addAction(UIAlertAction(title: "yes", style: UIAlertAction.Style.destructive, handler: { (_) in
            self.count = 0
            self.timer.invalidate()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func playButtonTap(_ sender: Any){
        if(isCountTimer){
            isCountTimer = false
            timer.invalidate()
            playButton.setTitle("START", for: .normal)
        }
        else{
            isCountTimer = true
            playButton.setTitle("PAUSE", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }

    @objc func timerCounter() -> Void{
        count = count - 1
        timerLabel.text = setTimerTextLabel()
    }
    
    func setTimerTextLabel() -> String {
        let hours = count / 3600
        let minutes = (count % 3600)/60
        let seconds = (count % 3600) % 60
        let timeString = createTimeString(hours: hours, minutes: minutes, seconds: seconds)
        return timeString
    }

    func createTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        let hourString = String(format: "%02d", hours)
        let minuteString = String(format: "%02d", minutes)
        let secondString = String(format: "%02d", seconds)
        timeString = hourString + " : " + minuteString + " : " + secondString
        return timeString
    }
}
