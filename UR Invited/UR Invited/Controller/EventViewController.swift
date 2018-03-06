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

class EventViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource, UITextFieldDelegate{
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView() //activity indicator variable
    var nflDic = [[String:AnyObject]]() //Array of dictionary for NFL
    var nbaDic = [[String:AnyObject]]() //Array of dictionary for NBA
    var mlbDic = [[String:AnyObject]]() //Array of dictionary for MLB
    var nascarDic = [[String:AnyObject]]() //Array of dictionary for NASCAR
    var ncaaBasketballDic = [[String:AnyObject]]() //Array of dictionary for NASCAR
    var ncaaFootballDic = [[String:AnyObject]]() //Array of dictionary for NASCAR
    var ncaaSportsDic = [Event]() //Array of dictionary for College Sports
    var tempCFB = [Event]() // Temporary Array for college football to be sorted
    var tempCBB = [Event]() // Temporary Array for college basketball to be sorted
    var eventDic = [Event]() // array of events
    var filteredEvent = [Event]() // array of events filtered with the search
    var eventNameInStringForSearch = [String]() // array of just the name of the event in order to search as a string
    var titles = ["NBA", "MLB", "NFL", "NASCAR", "CSPORTS"] // titles for the sections
    var date = Date();
    var dateFormatter = DateFormatter() // for api changing date to actual date
    let dispatchGroup = DispatchGroup()
    let screenSize = UIScreen.main.bounds
    var friendsView: UIView! // UIView to display the friends to invite
    
    @IBOutlet weak var searchQuery: UITextField!
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        searchQuery.delegate = self
        
        getSportsFromApis () // Load the data from the API
        dispatchGroup.notify(queue: .main){
            
            self.storeEvents() // Store the events in the an event array
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            //ends here
            
            self.displayEvents()
        }
        
    }
    // MARK:- table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as? EventTableViewCell else {return UITableViewCell()}
        cell.eventCollectionView.delegate = self
        cell.eventCollectionView.dataSource = self
        cell.eventCollectionView.tag = indexPath.row
        
        cell.sportsTitleLabel.text = titles[indexPath.row]
        cell.eventCollectionView.reloadData()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 0{
            return nbaDic.count
        }
        if collectionView.tag == 1{
            return mlbDic.count
        }
        if collectionView.tag == 2{
            return nflDic.count
        }
        if collectionView.tag == 3{
            return nascarDic.count
        }
        if collectionView.tag == 4{
            return ncaaSportsDic.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventSectionCollectionViewCell",for: indexPath) as? EventCollectionViewCell else {return UICollectionViewCell()}
        
        // Event DISPLAY CODE
        if collectionView.tag == 0 && eventDic[indexPath.row].category == "NBA"{
            
            cell.eventImage.image = UIImage(named: "nba.png")
            cell.eventNameLabel.text = eventDic[indexPath.row].name
        }
        if collectionView.tag == 1 && eventDic[nbaDic.count + indexPath.row].category == "MLB"{
            cell.eventImage.image = UIImage(named: "mlb.png")
            cell.eventNameLabel.text = eventDic[nbaDic.count + indexPath.row].name
        }
        if collectionView.tag == 2 && eventDic[nbaDic.count + mlbDic.count + indexPath.row].category == "NFL"{
            cell.eventImage.image = UIImage(named: "nfl.jpg")
            cell.eventNameLabel.text = eventDic[nbaDic.count + mlbDic.count + indexPath.row].name
        }
        if collectionView.tag == 3 && eventDic[nbaDic.count + mlbDic.count + nflDic.count + indexPath.row].category == "NASCAR"{
            cell.eventImage.image = UIImage(named: "nascar.jpg")
            cell.eventNameLabel.text = eventDic[nbaDic.count + mlbDic.count  + nflDic.count + indexPath.row].name
        }
        if collectionView.tag == 4 && eventDic[nbaDic.count + mlbDic.count + nflDic.count + nascarDic.count + indexPath.row].category == "CSPORTS"{
            cell.eventImage.image = UIImage(named: "College.jpg")
            cell.eventNameLabel.text = eventDic[nbaDic.count + mlbDic.count + nflDic.count + nascarDic.count + indexPath.row].name
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events NBA
        if collectionView.tag == 0 {
            
            displayFriendsUiViewController(nameOfEvent: eventDic[indexPath.item].name)
        }
        // handle tap events MLB
        if collectionView.tag == 1 {
            
            displayFriendsUiViewController(nameOfEvent: eventDic[nbaDic.count + indexPath.item].name)
            
        }
        // handle tap events NFL
        if collectionView.tag == 2 {
            
            displayFriendsUiViewController(nameOfEvent: eventDic[nbaDic.count + mlbDic.count + indexPath.item].name)
            
        }
        // handle tap events NASCAR
        if collectionView.tag == 3 {
            
            displayFriendsUiViewController(nameOfEvent: eventDic[nbaDic.count + mlbDic.count  + nflDic.count + indexPath.item].name)
        }
        // handle tap events COLLEGESPORTS
        if collectionView.tag == 4 {
            
            displayFriendsUiViewController(nameOfEvent: eventDic[nbaDic.count + mlbDic.count + nflDic.count + nascarDic.count + indexPath.item].name)
        }
    }
    
    // UITextField Delagates
    // UITextField Delagates ends
    // NBA alamofire gathering of data
    func getMySportsFeedUrlNBA(api_url: String){
        
        dispatchGroup.enter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print("get sports function")
        Alamofire.request("\(api_url)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers:MYSPORTS_API_HEADERS)
            .validate()
            .responseJSON { response in
                if(( response.result.value) != nil){
                    let swiftyJsonVar = JSON(response.result.value!) // entro el dict agarradp
                    
                    if let resData = swiftyJsonVar["fullgameschedule"]["gameentry"].arrayObject{
                        
                        for element in resData{
                            var temp = element as! [String:AnyObject]
                            
                            if let apisDate = self.dateFormatter.date(from: temp["date"] as! String)
                            {
                                
                                if self.date <= apisDate {
                                    
                                    self.nbaDic.append(temp)
                                }
                            }
                        }
                    }
                    
                    if self.nbaDic.count > 0{
                        self.dispatchGroup.leave()
                    }
                    
                }
        }
    }
    
    /// MLB alamofire gathering of data
    func getMySportsFeedUrlMLB(api_url: String){
        dispatchGroup.enter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        Alamofire.request("\(api_url)",
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers:MYSPORTS_API_HEADERS)
            .validate()
            .responseJSON { response in
                if response.result.value != nil{
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    // Trying to store in dictionary of sports
                    if let resData = swiftyJsonVar["fullgameschedule"]["gameentry"].arrayObject {
                        
                        for element in resData{
                            
                            var temp = element as! [String:AnyObject]
                            
                            if let apisDate = self.dateFormatter.date(from: temp["date"] as! String)
                            {
                                if self.date <= apisDate {
                                    
                                    self.mlbDic.append(temp)
                                }
                            }
                        }
                        
                    }
                    if self.mlbDic.count > 0{
                        self.dispatchGroup.leave()
                    }
                }
                
        }
    }
    
    /// Nfl alamofire gathering of data
    func getMySportsFeedUrlNFL(api_url: String){
        dispatchGroup.enter()
        Alamofire.request("\(api_url)",
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers:MYSPORTS_API_HEADERS)
            .validate()
            .responseJSON { response in
                if response.result.value != nil{
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    // Trying to store in dictionary of sports
                    if let resData = swiftyJsonVar["fullgameschedule"]["gameentry"].arrayObject {
                        self.nflDic = resData as! [[String:AnyObject]]
                    }
                    if self.nflDic.count > 0{
                        
                        self.dispatchGroup.leave()
                    }
                    
                }
        }
    }
    
    // NASCAR alamofire gathering of data
    func getMySportsFeedUrlNASCAR(api_url: String){
        dispatchGroup.enter()
        Alamofire.request("\(api_url)",
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers:MYNASCAR_API_HEADERS)
            .validate()
            .responseJSON { response in
                if response.result.value != nil{
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    // Trying to store in dictionary of sports
                    if let resData = swiftyJsonVar.arrayObject {
                        
                        self.nascarDic = resData as! [[String:AnyObject]]
                    }
                    if self.nascarDic.count > 0{
                        
                        self.dispatchGroup.leave()
                    }
                }
        }
    }
    
    // NCAA BASKETBALL alamofire gathering of data
    func getMySportsFeedUrlNCAABASKETBALL(api_url: String){
        
        dispatchGroup.enter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        Alamofire.request("\(api_url)",
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers:MYNCAABASKETBALL_API_HEADERS)
            .validate()
            .responseJSON { response in
                if response.result.value != nil{
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    // Trying to store in dictionary of sports
                    if let resData = swiftyJsonVar.arrayObject {
                        
                        for element in resData{
                            var temp = element as! [String:AnyObject]
                            
                            let dateString = temp["Day"] as! String
                            
                            if let index = (dateString.range(of: "T")?.lowerBound)
                            {
                                //prints "date"
                                let finalDate = String(dateString.prefix(upTo: index))
                                
                                if let apisDate = self.dateFormatter.date(from: finalDate)
                                {
                                    if self.date <= apisDate {
                                        
                                        self.ncaaBasketballDic.append(temp)
                                    }
                                }
                            }
                            
                        }
                    }
                    if self.ncaaBasketballDic.count > 0{
                        
                        self.dispatchGroup.leave()
                    }
                }
        }
    }
    
    // NCAA FOOTBALL alamofire gathering of data
    func getMySportsFeedUrlNCAAFOOTBALL(api_url: String){
        
        dispatchGroup.enter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        Alamofire.request("\(api_url)",
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers:MYNCAAFOOTBALL_API_HEADERS)
            .validate()
            .responseJSON { response in
                if response.result.value != nil{
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    // Trying to store in dictionary of sports
                    if let resData = swiftyJsonVar.arrayObject {
                        
                        for element in resData{
                            var temp = element as! [String:AnyObject]
                            
                            let dateString = temp["Day"] as! String
                            
                            if let index = (dateString.range(of: "T")?.lowerBound)
                            {
                                //prints "date"
                                let finalDate = String(dateString.prefix(upTo: index))
                                
                                if let apisDate = self.dateFormatter.date(from: finalDate)
                                {
                                    if self.date <= apisDate {
                                        
                                        self.ncaaFootballDic.append(temp)
                                    }
                                }
                            }
                        }
                    }
                    if self.ncaaFootballDic.count > 0{
                        
                        self.dispatchGroup.leave()
                    }
                }
        }
    }
    
    func displayEvents (){
        
        DispatchQueue.main.async(execute: {
            self.eventsTableView.reloadData()
        })
    }
    func getSportsFromApis () {
        
        // activity indicator to be placed here
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
//        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // activity indicator to be ended here
        
        getMySportsFeedUrlNBA(api_url:"https://api.mysportsfeeds.com/v1.2/pull/nba/2017-2018-regular/full_game_schedule.json")
        getMySportsFeedUrlMLB(api_url:"https://api.mysportsfeeds.com/v1.2/pull/mlb/2018-regular/full_game_schedule.json")
        getMySportsFeedUrlNFL(api_url:"https://api.mysportsfeeds.com/v1.2/pull/nfl/2018-playoff/full_game_schedule.json")
        getMySportsFeedUrlNASCAR(api_url:"https://api.fantasydata.net/nascar/v2/json/series")
        getMySportsFeedUrlNCAABASKETBALL(api_url:"https://api.fantasydata.net/v3/cbb/stats/JSON/Games/2018")
        getMySportsFeedUrlNCAAFOOTBALL(api_url:"https://api.fantasydata.net/v3/cfb/stats/JSON/Games/2018")
    }
    
    func storeEvents (){
        
        for nba in self.nbaDic{
            let tempName = "NBA | \(nba["homeTeam"]!["Name"] as! String) vs \(nba["awayTeam"]!["Name"] as! String)"
            let tempDate = nba["date"] as! String
            let tempCategory = "NBA"
            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory)
            
            self.eventDic.append(newEvent)
        }
        for mlb in self.mlbDic{
            let tempName = "MLB | \(mlb["homeTeam"]!["Name"] as! String) vs \(mlb["awayTeam"]!["Name"] as! String)"
            let tempDate = mlb["date"] as! String
            let tempCategory = "MLB"
            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory)
            self.eventDic.append(newEvent)
        }
        for nfl in self.nflDic{
            let tempName = "NFL | \(nfl["homeTeam"]!["Name"] as! String) vs \(nfl["awayTeam"]!["Name"] as! String)"
            let tempDate = nfl["date"] as! String
            let tempCategory = "NFL"
            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory)
            self.eventDic.append(newEvent)
        }
        for nascar in self.nascarDic{
            let tempName = "Nascar | \(nascar["Name"] as! String)"
            let tempDate = "0000-00-00"
            let tempCategory = "NASCAR"
            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory)
            self.eventDic.append(newEvent)
        }
        for ncaaBasketBall in self.ncaaBasketballDic{
            let tempName = "CBB | \(ncaaBasketBall["HomeTeam"] as! String) vs \(ncaaBasketBall["AwayTeam"] as! String)"
            let tempDate = ncaaBasketBall["Day"] as! String
            let tempCategory = "CBB" // CBB College BasketBall
            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory)
            self.tempCBB.append(newEvent) // temp array
        }
        for ncaaFootBall in self.ncaaFootballDic{
            let tempName = "CFB | \(ncaaFootBall["HomeTeam"] as! String) vs \(ncaaFootBall["AwayTeam"] as! String)"
            let tempDate = ncaaFootBall["Day"] as! String
            let tempCategory = "CFB" // CBB College BasketBall
            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory)
            self.tempCFB.append(newEvent) // temp array
        }
        self.getCollegeSportsInArray()
        for ncaaSportsinfo in self.ncaaSportsDic{
            let tempName = ncaaSportsinfo.name
            let tempDate = ncaaSportsinfo.date
            let tempCategory = "CSPORTS"
            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory)
            self.eventDic.append(newEvent)
        }
        
        // stores the name of the event in a string array for searching purpose
        //        for stringEvent in self.eventDic{
        //
        //            self.eventNameInStringForSearch.append(stringEvent.name)
        //        }
    }
    
    func getCollegeSportsInArray()
    {
        for i in 0..<ncaaBasketballDic.count
        {
            ncaaSportsDic.insert(tempCBB[i], at: 2 * i + 0)
            ncaaSportsDic.insert(tempCFB[i], at: 2 * i + 1)
        }
    }
    
    // function to create the UIView that displays the friends to invite
    func displayFriendsUiViewController(nameOfEvent: String){
        
        let popOverVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbFriendsPopUp") as! InviteFriendsPopUpViewController
        self.addChildViewController(popOverVc)
        popOverVc.view.frame = self.view.frame
        popOverVc.eventNameForGroupLabel.text = nameOfEvent
        self.view.addSubview(popOverVc.view)
        popOverVc.didMove(toParentViewController: self)
    }
    
    
}

