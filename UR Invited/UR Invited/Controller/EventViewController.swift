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
    //    var eventNameInStringForSearch = [String]() // array of just the name of the event in order to search as a string
    var titles = ["NBA", "MLB", "NFL","NASCAR"] // titles for the sections
    var date = Date();
    var dateFormatter = DateFormatter() // for api changing date to actual date
    let dispatchGroup = DispatchGroup()
    let screenSize = UIScreen.main.bounds
    var friendsView: UIView! // UIView to display the friends to invite
    var searchEventArray = [Event] () // copy of main event array
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil) // the entire storyboard variable
    
    @IBOutlet weak var searchQuery: UITextField! // search bar textfield to find events
    @IBOutlet weak var eventsTableView: UITableView! // main tableview to display event content
    
    @IBOutlet weak var closeButton: UIButton! // button to return to the main view after the user quits editing
    override func viewDidLoad() {
        
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        searchQuery.delegate = self
        closeButton.isHidden = true
        getSportsFromApis () // Load the data from the API
        
        let nib = UINib(nibName: "EventSearchTableViewCell", bundle: nil)
        self.eventsTableView.register(nib, forCellReuseIdentifier: "EventSearchTableViewCell")
        
        
        searchQuery.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        dispatchGroup.notify(queue: .main){
            
            self.storeEvents() // Store the events in the an event array
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            //ends here
            
            //            print ("Begging of Nascar: \(self.nbaDic)")
            
            
            
            self.displayEvents()
            self.searchEventArray = self.eventDic
            
        }
        
    }
    
    // Beginning of Actions to begin Event Search & Close search
    
    // Close button action to return to main event view
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        searchQuery.text = ""
        searchQuery.endEditing(true)
        
        eventsTableView.reloadData()
        
        print ("Close button was pressed")
    }
    
    // if the user begins typing an event display the search view
    // Function to execute whenever textfield changes
    @objc func textFieldDidChange () {
        
        closeButton.isHidden = false
        
        eventsTableView.allowsSelection = true
        
        if searchQuery.text == "" {
            searchEventArray = eventDic
            self.eventsTableView.reloadData()
        } else {
            var eventArray = [Event]()
            for event in eventDic {
                
                if event.name.lowercased().contains(searchQuery.text!.lowercased()) == true || event.date.lowercased().contains(searchQuery.text!.lowercased()) == true || event.homeTeamCity?.lowercased().contains(searchQuery.text!.lowercased()) == true || event.awayTeamCity?.lowercased().contains(searchQuery.text!.lowercased()) == true || event.category.lowercased().contains(searchQuery.text!.lowercased()) == true {
                    
                    eventArray.append(event)
                }
            }
            searchEventArray = eventArray
            self.eventsTableView.reloadData()
        }
    }
    
    // End of Actions to begin Event Search & Close search
    
    
    // MARK:- table view delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchQuery.isEditing  {
            return searchEventArray.count
        }else{
            return titles.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchQuery.isEditing {
            return 44
        } else {
            return 228
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nowString = dateFormatter.string(from: date)
        let nowDate = self.dateFormatter.date(from: nowString)
        
        if !searchQuery.isEditing {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as? EventTableViewCell else {return UITableViewCell()}
            cell.eventCollectionView.delegate = self
            cell.eventCollectionView.dataSource = self
            cell.eventCollectionView.tag = indexPath.row
            
            cell.sportsTitleLabel.text = titles[indexPath.row]
            cell.eventCollectionView.reloadData()
            return cell
        }else{
            // here goes the xib file values
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventSearchTableViewCell") as? EventSearchTableViewCell else {return UITableViewCell()}
            
            let stringDate = searchEventArray[indexPath.row].date
            let newDateFixed = stringDate.replacingOccurrences(of: "-", with: "/", options: .literal, range: nil)
            let tempDate = newDateFixed.replacingOccurrences(of: "2018/", with: "", options: .literal, range: nil)
            let eventDate = self.dateFormatter.date(from: stringDate)
            let tomorrow = Calendar.current.date(byAdding:
                .day, // updated this params to add hours
                value: 1,
                to: nowDate!)
            
            cell.eventNameLabel.text = searchEventArray[indexPath.row].name
            
            if eventDate == nowDate
            {
                cell.eventDateForSearch.text = "Today"
            }else if eventDate == tomorrow{
                cell.eventDateForSearch.text = "Tomorrow"
            }else{
                cell.eventDateForSearch.text = tempDate
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? EventSearchTableViewCell else {return}
        
        // Set color of cell when selected
        let bgColorView = UIView()
        bgColorView.backgroundColor = #colorLiteral(red: 0.2041445076, green: 0.1733199656, blue: 0.297611773, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        // Return to normal view
        closeButton.isHidden = true
        searchQuery.text = ""
        searchQuery.endEditing(true)
        eventsTableView.reloadData()
        
        // Display invitation
        displayFriendsUiViewController(nameOfEvent: cell.eventNameLabel.text!)
        
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
        //        if collectionView.tag == 4{
        //            return ncaaSportsDic.count
        //        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventSectionCollectionViewCell",for: indexPath) as? EventCollectionViewCell else {return UICollectionViewCell()}
        
        // todays date formated already
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nowString = dateFormatter.string(from: date)
        let nowDate = self.dateFormatter.date(from: nowString)
        // Event DISPLAY CODE
        if collectionView.tag == 0 && eventDic[indexPath.row].category == "NBA"{
            
            cell.eventImage.image = UIImage(named: "nba.png")
            cell.eventNameLabel.text = eventDic[indexPath.row].name
            let stringDate = eventDic[indexPath.row].date
            let newDateFixed = stringDate.replacingOccurrences(of: "-", with: "/", options: .literal, range: nil)
            let tempDate = newDateFixed.replacingOccurrences(of: "2018/", with: "", options: .literal, range: nil)
            let eventDate = self.dateFormatter.date(from: stringDate)
            let tomorrow = Calendar.current.date(byAdding:
                .day, // updated this params to add hours
                value: 1,
                to: nowDate!)
            // checking if the date is today or tomorrow
            if eventDate == nowDate
            {
                cell.eventDate.text = "Today"
            }else if eventDate == tomorrow{
                cell.eventDate.text = "Tomorrow"
            }else{
                cell.eventDate.text = tempDate
            }
            
        }
        if collectionView.tag == 1 && eventDic[nbaDic.count + indexPath.row].category == "MLB"{
            
            // todays date formated already
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let nowString = dateFormatter.string(from: date)
            let nowDate = self.dateFormatter.date(from: nowString)
            
            cell.eventImage.image = UIImage(named: "mlb.png")
            cell.eventNameLabel.text = eventDic[nbaDic.count + indexPath.row].name
            let stringDate = eventDic[nbaDic.count + indexPath.row].date
            let newDateFixed = stringDate.replacingOccurrences(of: "-", with: "/", options: .literal, range: nil)
            let tempDate = newDateFixed.replacingOccurrences(of: "2018/", with: "", options: .literal, range: nil)
            let eventDate = self.dateFormatter.date(from: stringDate)
            let tomorrow = Calendar.current.date(byAdding:
                .day, // updated this params to add hours
                value: 1,
                to: nowDate!)
            // checking if the date is today or tomorrow
            if eventDate == nowDate
            {
                cell.eventDate.text = "Today"
            }else if eventDate == tomorrow{
                cell.eventDate.text = "Tomorrow"
            }else{
                cell.eventDate.text = tempDate
            }
        }
        if collectionView.tag == 2 && eventDic[nbaDic.count + mlbDic.count + indexPath.row].category == "NFL"{
            cell.eventImage.image = UIImage(named: "nfl.jpg")
            cell.eventNameLabel.text = eventDic[nbaDic.count + mlbDic.count + indexPath.row].name
            let stringDate = eventDic[nbaDic.count + mlbDic.count + indexPath.row].date
            let newDateFixed = stringDate.replacingOccurrences(of: "-", with: "/", options: .literal, range: nil)
            let tempDate = newDateFixed.replacingOccurrences(of: "2018/", with: "", options: .literal, range: nil)
            cell.eventDate.text = tempDate
            
        }
        if collectionView.tag == 3 && eventDic[nbaDic.count + mlbDic.count + nflDic.count + indexPath.row].category == "NASCAR"{
            cell.eventImage.image = UIImage(named: "nascar.jpg")
            cell.eventNameLabel.text = eventDic[nbaDic.count + mlbDic.count  + nflDic.count + indexPath.row].name
            cell.eventDate.text = ""
        }
        //        if collectionView.tag == 4 && eventDic[nbaDic.count + mlbDic.count + nflDic.count + nascarDic.count + indexPath.row].category == "CSPORTS"{
        //            cell.eventImage.image = UIImage(named: "College.jpg")
        //            cell.eventNameLabel.text = eventDic[nbaDic.count + mlbDic.count + nflDic.count + nascarDic.count + indexPath.row].name
        //        }
        
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
        //        // handle tap events COLLEGESPORTS
        //        if collectionView.tag == 4 {
        //
        //            displayFriendsUiViewController(nameOfEvent: eventDic[nbaDic.count + mlbDic.count + nflDic.count + nascarDic.count + indexPath.item].name)
        //        }
    }
    
    // UITextField Delagates
    // UITextField Delagates ends
    // NBA alamofire gathering of data
    func getMySportsFeedUrlNBA(api_url: String){
        
        dispatchGroup.enter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let now = dateFormatter.string(from: date)
        
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
                                if let newDate = self.dateFormatter.date(from: now ){
                                    
                                    if newDate <= apisDate {
                                        
                                        self.nbaDic.append(temp)
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    if self.nbaDic.count > 0{
                        
                        print ("NBA: \(self.nbaDic)")
                        self.dispatchGroup.leave()
                    }else if self.nbaDic.count < 0{
                        print ("NBA DID NOT LOAD")
                    }
                    
                }
        }
    }
    
    /// MLB alamofire gathering of data
    func getMySportsFeedUrlMLB(api_url: String){
        dispatchGroup.enter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let now = dateFormatter.string(from: date)
        
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
                                
                                if let newDate = self.dateFormatter.date(from: now ){
                                    
                                    if newDate <= apisDate {
                                        
                                        self.mlbDic.append(temp)
                                    }
                                }
                            }
                        }
                        
                    }
                    if self.mlbDic.count > 0{
                        self.dispatchGroup.leave()
                    }else if self.mlbDic.count < 0{
                        print ("MLB DID NOT LOAD")
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
                    }else if self.nflDic.count < 0{
                        print ("NFL did not load")
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
                    }else if self.nascarDic.count < 0{
                        print ("NASCAR DID NOT LOAD")
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
        activityIndicator.color = UIColor.white
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        //        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // activity indicator to be ended here
        
        getMySportsFeedUrlNBA(api_url:"https://api.mysportsfeeds.com/v1.2/pull/nba/2018-playoff/full_game_schedule.json")
        getMySportsFeedUrlMLB(api_url:"https://api.mysportsfeeds.com/v1.2/pull/mlb/2018-regular/full_game_schedule.json")
        getMySportsFeedUrlNFL(api_url:"https://api.mysportsfeeds.com/v1.2/pull/nfl/2018-playoff/full_game_schedule.json")
        getMySportsFeedUrlNASCAR(api_url:"https://api.fantasydata.net/nascar/v2/json/series")
        //        getMySportsFeedUrlNCAABASKETBALL(api_url:"https://api.fantasydata.net/v3/cbb/stats/JSON/Games/2018")
        //        getMySportsFeedUrlNCAAFOOTBALL(api_url:"https://api.fantasydata.net/v3/cfb/stats/JSON/Games/2018")
    }
    
    func storeEvents (){
        
        dateFormatter.dateFormat = "MM/dd"
        
        for nba in self.nbaDic{
            let tempName = "NBA | \(nba["homeTeam"]!["Name"] as! String) vs \(nba["awayTeam"]!["Name"] as! String)"
            let tempDate = nba["date"] as! String
            let tempHomeTeamCity = nba["homeTeam"]!["City"] as! String
            let tempAwayTeamCity = nba["awayTeam"]!["City"] as! String
            let tempCategory = "NBA"
            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory, homeTeamCity: tempHomeTeamCity, awayTeamCity: tempAwayTeamCity)
            
            self.eventDic.append(newEvent)
        }
        for mlb in self.mlbDic{
            let tempName = "MLB | \(mlb["homeTeam"]!["Name"] as! String) vs \(mlb["awayTeam"]!["Name"] as! String)"
            let tempDate = mlb["date"] as! String
            let tempHomeTeamCity = mlb["homeTeam"]!["City"] as! String
            let tempAwayTeamCity = mlb["awayTeam"]!["City"] as! String
            let tempCategory = "MLB"
            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory, homeTeamCity: tempHomeTeamCity, awayTeamCity: tempAwayTeamCity)
            self.eventDic.append(newEvent)
        }
        for nfl in self.nflDic{
            let tempName = "NFL | \(nfl["homeTeam"]!["Name"] as! String) vs \(nfl["awayTeam"]!["Name"] as! String)"
            let tempDate = nfl["date"] as! String
            let tempHomeTeamCity = nfl["homeTeam"]!["City"] as! String
            let tempAwayTeamCity = nfl["awayTeam"]!["City"] as! String
            let tempCategory = "NFL"
            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory, homeTeamCity: tempHomeTeamCity, awayTeamCity: tempAwayTeamCity)
            self.eventDic.append(newEvent)
        }
        for nascar in self.nascarDic{
            let tempName = "Nascar | \(nascar["Name"] as! String)"
            let tempDate = "0000-00-00"
            let tempCategory = "NASCAR"
            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory, homeTeamCity: "", awayTeamCity: "")
            self.eventDic.append(newEvent)
        }
        //        for ncaaBasketBall in self.ncaaBasketballDic{
        //            let tempName = "CBB | \(ncaaBasketBall["HomeTeam"] as! String) vs \(ncaaBasketBall["AwayTeam"] as! String)"
        //            let tempDate = ncaaBasketBall["Day"] as! String
        //            let tempCategory = "CBB" // CBB College BasketBall
        //            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory)
        //            self.tempCBB.append(newEvent) // temp array
        //        }
        //        for ncaaFootBall in self.ncaaFootballDic{
        //            let tempName = "CFB | \(ncaaFootBall["HomeTeam"] as! String) vs \(ncaaFootBall["AwayTeam"] as! String)"
        //            let tempDate = ncaaFootBall["Day"] as! String
        //            let tempCategory = "CFB" // CBB College BasketBall
        //            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory)
        //            self.tempCFB.append(newEvent) // temp array
        //        }
        //        self.getCollegeSportsInArray()
        //        for ncaaSportsinfo in self.ncaaSportsDic{
        //            let tempName = ncaaSportsinfo.name
        //            let tempDate = ncaaSportsinfo.date
        //            let tempCategory = "CSPORTS"
        //            let newEvent = Event(name: tempName, date: tempDate, category: tempCategory)
        //            self.eventDic.append(newEvent)
        //        }
        
        //         stores the name of the event in a string array for searching purpose
        //        for stringEvent in self.eventDic{
        //
        //            self.eventNameInStringForSearch.append(stringEvent.name)
        //        }
        
    }
    //
    //    func getCollegeSportsInArray()
    //    {
    //        for i in 0..<ncaaBasketballDic.count
    //        {
    //            ncaaSportsDic.insert(tempCBB[i], at: 2 * i + 0)
    //            ncaaSportsDic.insert(tempCFB[i], at: 2 * i + 1)
    //        }
    //    }
    
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

