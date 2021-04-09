//
//  PlanModel.swift
//  Memofy2
//
//  Created by Hannatassja Hardjadinata on 06/04/21.
//

import Foundation


class Plan: NSObject, NSCoding
{
    //Set Key Value
    func encode(with coder: NSCoder) {
        coder.encode(index, forKey: "index")
        coder.encode(status, forKey: "status")
        coder.encode(studyPlan, forKey: "studyPlan")
        coder.encode(studyNotes, forKey: "studyNotes")
        coder.encode(frequency, forKey: "frequency")
        coder.encode(startsDate, forKey: "startsDate")
        coder.encode(endsDate, forKey: "endsDate")
        coder.encode(timeReminder, forKey: "timeReminder")
        coder.encode(switchReminder, forKey: "switchReminder")
        coder.encode(studyDuration, forKey: "studyDuration")
        coder.encode(breakDuration, forKey: "breakDuration")
    }
    
    //index Int
    //studyPlan String
    //studyNotes String
    //days Int
    //startsDate Date
    //endsDate Date
    //timeReminder Date
    //studyDuration Int
    //breakDuration Int
    
    
    required convenience init?(coder: NSCoder) {
        
        //Pastikan data tidak kosong
//        guard let index = coder.decodeObject(forKey: "index") as? Int,
        guard let status = coder.decodeObject(forKey: "status") as? String,
                    let studyPlan = coder.decodeObject(forKey: "studyPlan") as? String,
                    let studyNotes = coder.decodeObject(forKey: "studyNotes") as? String,
                    let frequency = coder.decodeObject(forKey: "frequency") as? [Int],
                    let startsDate = coder.decodeObject(forKey: "startsDate") as? Date,
                    let endsDate = coder.decodeObject(forKey: "endsDate") as? Date,
                    let timeReminder = coder.decodeObject(forKey: "timeReminder") as? Date
            else { return nil }

            //convert data jadi strings
            self.init(
                index: coder.decodeInteger(forKey: "index"),
                status: status,
                studyPlan: studyPlan,
                studyNotes: studyNotes,
                frequency: frequency,
                startsDate: startsDate,
                endsDate: endsDate,
                timeReminder: timeReminder,
                switchReminder: coder.decodeBool(forKey: "switchReminder"),
                studyDuration: coder.decodeInteger(forKey: "studyDuration"),
                breakDuration: coder.decodeInteger(forKey: "breakDuration")
                //published: coder.decodeInteger(forKey: "published") //untuk Int
            )
    }
    
    var index: Int
    var status: String
    var studyPlan: String
    var studyNotes: String
    var frequency: [Int]
    var startsDate: Date
    var endsDate: Date
    var timeReminder: Date
    var switchReminder : Bool
    var studyDuration: Int
    var breakDuration: Int
    
//    init(index: Int, studyPlan: String, studyNotes: String, frequency: [Int], startsDate: Date, endsDate: Date, timeReminder: Date, switchReminder: Bool, studyDuration: Int, breakDuration: Int)
//    {
//        self.index = index
//        self.studyPlan = studyPlan
//        self.studyNotes = studyNotes
//        self.frequency = frequency
//        self.startsDate = startsDate
//        self.endsDate = endsDate
//        self.timeReminder = timeReminder
//        self.switchReminder = switchReminder
//        self.studyDuration = studyDuration
//        self.breakDuration = breakDuration
//    }
    
    init(index: Int, status: String, studyPlan: String, studyNotes: String, frequency: [Int], startsDate: Date, endsDate: Date, timeReminder: Date, switchReminder: Bool, studyDuration: Int, breakDuration: Int)
    {
        self.index = index
        self.status = status
        self.studyPlan = studyPlan
        self.studyNotes = studyNotes
        self.frequency = frequency
        self.startsDate = startsDate
        self.endsDate = endsDate
        self.timeReminder = timeReminder
        self.switchReminder = switchReminder
        self.studyDuration = studyDuration
        self.breakDuration = breakDuration
        
    }

}
