//
//  EventHandelerClass.swift
//  UR Invited
//
//  Created by Valley Technical Academy on 2/7/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import Foundation

class Event{
    var name:String
    var date:String
    var homeTeamCity:String?
    var awayTeamCity:String?
    var category:String
    
    
    init (name: String, date: String, category: String, homeTeamCity:String?, awayTeamCity:String?) {
        self.name = name
        self.date = date
        self.category = category
        if let homeCityName = homeTeamCity {
            self.homeTeamCity = homeCityName
        } else {return}
        
        if let awayCityName = awayTeamCity {
            self.awayTeamCity = awayCityName
        } else {return}
        
    }
}


