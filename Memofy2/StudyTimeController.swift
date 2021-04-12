//
//  ViewController.swift
//  Memofy2
//
//  Created by JACKY on 23/03/21.
//

import UIKit

class StudyTimeController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var breakLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var timerTimer:Timer = Timer()
    var timerBreak: Timer = Timer()
    var countTimer:Int = 3602
    var countBreak: Int = 10
    
    var isCountTimer:Bool = false
    var isCountBreak:Bool = false
    var isTimer: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.setTitle("START", for: .normal)
        stopButton.setTitle("Done Study", for: .normal)
        
        stopButton.isHidden = true
        timerLabel.text = setTimerTextLabel(dataSeconds: countTimer)
        
        breakLabel.isHidden = true
        
    }
    
    
    
    @IBAction func stopButtonTap(_ sender: Any){
        let alert = UIAlertController(title: "Complete Study?", message: "if you click done, your study will be completed", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { (_) in
            self.stopTimer()
            self.stopBreak()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { (_) in
            print("cancel")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func startTimer(){
        self.isTimer = true
        self.timerLabel.isHidden = false
        self.playButton.setTitle("PAUSE", for: .normal)
        self.timerTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    func pauseTimer(){
        self.timerLabel.isHidden = true
        self.timerTimer.invalidate()
        self.playButton.setTitle("START", for: .normal)
    }
    
    func stopTimer() {
        self.countTimer = 0
        self.timerTimer.invalidate()
        self.isCountTimer = false
        self.playButton.setTitle("START", for: .normal)
        self.timerLabel.text = self.setTimerTextLabel(dataSeconds: self.countTimer)
    }

    
    func startBreak(){
        self.isTimer = false
        self.breakLabel.text = self.setTimerTextLabel(dataSeconds: self.countBreak)
        self.breakLabel.isHidden = false
        if(countBreak > 0) {
            timerBreak = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(breakCounter), userInfo: nil, repeats: true)
        }
       
    }
    
    func pauseBreak(){
        self.breakLabel.isHidden = true
        self.timerBreak.invalidate()
//        playButton.setImage(UIImage(named:"Play Button.png"), for: .normal)
    }
    
    func stopBreak() {
        self.countBreak = 0
        self.timerBreak.invalidate()
        self.isCountBreak = false
        self.breakLabel.text = self.setTimerTextLabel(dataSeconds: self.countBreak)
    }
    
    @IBAction func playButtonTap(_ sender: Any){
        stopButton.isHidden = false
        if(isCountTimer){
            isCountTimer = false
//            playButton.setImage(UIImage(named:"Play Button.png"), for: .normal)
            pauseTimer()
            startBreak()
        }
        else{
            if countTimer == 0 {
                return
            }
            
            isCountTimer = true
            playButton.setImage(UIImage(named:"Pause Button.png"), for: .normal)
            pauseBreak()
            startTimer()
        }
    }

    @objc func timerCounter() -> Void{
        countTimer = countTimer - 1
        timerLabel.text = setTimerTextLabel(dataSeconds: countTimer)
        if countTimer == 0 {
            stopTimer()
        }
    }
    
    @objc func breakCounter() -> Void{
        countBreak = countBreak - 1
        breakLabel.text = setTimerTextLabel(dataSeconds: countBreak)
        if countBreak == 0 {
            stopBreak()
        }
    }
    
    func setTimerTextLabel(dataSeconds: Int) -> String {
        let hours = dataSeconds / 3600
        let minutes = (dataSeconds % 3600)/60
        let seconds = (dataSeconds % 3600) % 60
        let timeString = createTimeString(hours: hours, minutes: minutes, seconds: seconds)
        return timeString
    }

    func createTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        let hourString = String(format: "%02d", hours)
        let minuteString = String(format: "%02d", minutes)
        let secondString = String(format: "%02d", seconds)
        if isTimer {
            timeString = hourString + " : " + minuteString + " : " + secondString
        }else{
            timeString = minuteString + " : " + secondString
        }
        return timeString
    }
}
