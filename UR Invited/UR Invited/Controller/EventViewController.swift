//
//  EventViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 2/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventViewController: UIViewController {
    
    //var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = "appdevAntonio"
        let password = "aguila14"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request("https://api.mysportsfeeds.com/v1.2/pull/nba/2017-2018-regular/full_game_schedule.json",
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers:headers)
            .validate()
            .responseJSON { response in
                if response.result.value != nil{
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    //                    if let resData = swiftyJsonVar[""].arrayObject {
                    //                        self.arrRes = resData as! [[String:AnyObject]]
                    //                    }
                    //                    if self.arrRes.count > 0 {
                    //                    }
                    
                    print(swiftyJsonVar["fullgameschedule"]["gameentry"][0]["awayTeam"]["Name"])
                    //                    print(swiftyJsonVar["fullgameschedule"]["gameentry"][0]["homeTeam"])
                }
                
        }
        
    }
    
    
}
