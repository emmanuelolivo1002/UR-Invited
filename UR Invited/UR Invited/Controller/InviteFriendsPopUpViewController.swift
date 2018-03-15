//
//  InviteFriendsPopUpViewController.swift
//  UR Invited
//
//  Created by Valley Technical Academy on 2/28/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import Firebase

class InviteFriendsPopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    // MARK: Outlets
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var friendsToInviteTableView: UITableView! // table view for the group
    @IBOutlet weak var eventNameForGroupLabel: UILabel! // name of the group label
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var groupNameView: UIView!
    
    // MARK: Variables
    
   
    
    // Array of users 
    var usersArray = [User]()
    var allUsersArray = [User]()
    
    // Array of users invited
    var usersInvited = [User]()

    

    
    
    // MARK: Actions
    @IBAction func skipButtonPress(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        DataService.instance.getUserData(forUID: (Auth.auth().currentUser?.uid)!) { (returnedUser) in
            self.usersInvited.append(returnedUser)
            
            
            DataService.instance.createGroup(withTitle: self.eventNameForGroupLabel.text!, forUsers: self.usersInvited, handler: { (groupCreated) in
                // Dismiss view once a new group is created
                if groupCreated {
                    print("Group was created")
                    
                    //TODO: Go to chatview
                    
                    // Select main storyboard
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    
                    // Select AuthViewController
                    let tabBarViewController = storyboard.instantiateInitialViewController() as! UITabBarController
                    tabBarViewController.selectedIndex = 0
                    
                    self.present(tabBarViewController, animated: true, completion: nil)
                    
                } else {
                    print("Group could not be created")
                }
            })
        }
    }

    
    // MARK: Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set self as tableview delegate and datasource
        friendsToInviteTableView.delegate = self
        friendsToInviteTableView.dataSource = self
        
      

        // Set self as delegate of textfield
        searchTextField.delegate = self
        // Add target whenever textfield changes
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // Set up view buttons
        saveButton.isHidden = true
        skipButton.isHidden = false

        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        groupNameView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load users array
        print("Loading array")
        DataService.instance.getAllUsers { (returnedUsersArray) in
            self.usersArray = returnedUsersArray
            self.allUsersArray = self.usersArray
            
            
            
            self.friendsToInviteTableView.reloadData()
        }
        
    }
    
    // Function to execute whenever textfield changes
    @objc func textFieldDidChange () {
        
        // if search query is empty show the array as empty
        if searchTextField.text == "" {
            usersArray = allUsersArray
            friendsToInviteTableView.reloadData()
        } else {
            
            // if there is a search in textfield start getting emails from database
            
            DataService.instance.getUsers(forSearchQuery: searchTextField.text!, handler: { (returnedUsersArray) in
                
                
                // Load usersArray with result and reload the data
                self.usersArray = returnedUsersArray.filter({ $0.uid != Auth.auth().currentUser?.uid})
                self.friendsToInviteTableView.reloadData()
            })
        }
        
    }
    

    
    // Table view methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsInvitationTableViewCell") as? FriendsInvitationTableViewCell else {return UITableViewCell()}
        
        // Configure User Cell depending on whether or not user is in the array
        if usersInvited.contains(where: { $0.uid == usersArray[indexPath.row].uid }) {
            cell.configureCell(user: usersArray[indexPath.row], isSelected: true)
        } else {
         cell.configureCell(user: usersArray[indexPath.row], isSelected: false)
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as?  FriendsInvitationTableViewCell else {return}
        
        // Set color of cell when selected
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = bgColorView
        
        // Toggle between invite and invited
        
        // If selected user is NOT in array of users invited
        if !usersInvited.contains(where: { $0.uid == cell.idLabel.text!}) {
            
            print("user TO BE added to array: \(cell.usernameLabel.text!)")
            
            // Append user to invited array
            usersInvited.append(usersArray[indexPath.row])
            
            print("user added to array: \(String(describing: usersInvited.last))")
            
            print("usersInvited count: \(usersInvited.count)")
            
            // Change label to Invited
            cell.invitedLabel.textColor = #colorLiteral(red: 0.9294117647, green: 0.568627451, blue: 0.2078431373, alpha: 1)
            cell.invitedLabel.text = "INVITED"
            
            // Toggle the buttons
            skipButton.isHidden = true
            saveButton.isHidden = false
            
        } else {
            // If user IS in array
            
            // Change label to Invite
            cell.invitedLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.662745098, blue: 0.7176470588, alpha: 1)
            cell.invitedLabel.text = "INVITE"
          
            // Remove it from the array of users invited
            usersInvited = usersInvited.filter({ $0.uid != cell.idLabel.text!})
            
            // If array is empty show the skip button and hide save button
            if usersInvited.count == 0 {
                skipButton.isHidden = false
                saveButton.isHidden = true
            }
        }
    }
    
    // MARK: Selectors
    // tableViewTapped Method
    @objc func tableViewTapped() {
        view.endEditing(true)
    }

}
