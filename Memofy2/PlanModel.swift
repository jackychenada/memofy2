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
        coder.encode(name, forKey: "name")
        coder.encode(status, forKey: "status")
        
    }
    
    
    required convenience init?(coder: NSCoder) {
        
        //Pastikan data tidak kosong
        guard let name = coder.decodeObject(forKey: "name") as? String,
              let status = coder.decodeObject(forKey: "status") as? String
            else { return nil }

            //convert data jadi strings
            self.init(
                name: name,
                status: status
                //published: coder.decodeInteger(forKey: "published") //untuk Int
            )
    }
    
    var name: String
    var status: String
    init(name: String, status: String)
    {
        self.name = name
        self.status = status
    }
}
