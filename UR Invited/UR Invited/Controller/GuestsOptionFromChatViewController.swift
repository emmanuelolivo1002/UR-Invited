//
//  GuestsOptionFromChatViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 13/03/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import Firebase

class GuestsOptionFromChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    //MARK: Outlets
    @IBOutlet weak var currentGuestTabButton: UIButton!
    @IBOutlet weak var findNewGuestTabButton: UIButton!
    @IBOutlet weak var closeGuestMenuButton: UIButton!
    @IBOutlet weak var findNewGuestUnderlineUIView: UIView!
    @IBOutlet weak var currentGuestUnderlineUIView: UIView!
    
    @IBOutlet weak var nameOfEventLabel: UILabel!
    @IBOutlet weak var currentGuestTableView: UITableView!
    
    @IBOutlet weak var searchTextField: WhitePlaceholderTextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var suggestedGuestLabel: UILabel! // hide this label when the user jumps into this screen
    
    // Constraint Outlets
    
    @IBOutlet weak var currentGuestButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var findNewGuestButtonHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: Variables
    
    // Current Group
    var group : Group?
    
    
    // Array of users
    
    var usersCurrentlyInGroup = [User]()
    
    var usersNotInGroup = [User]()
    
    var usersInvited = [User]()
    
    var usersDisplayed = [User]()
    
 
    
    
    var guestInvited = [String]() // array of members in the group
    var friendsNotYetInvited = [String] () // array of members not in the group
    
    var isCurrentGuestsButtonSelected = true
    
    var cellFlag = false
    
    
    // MARK: Actions
 
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        DataService.instance.inviteUsers(toGroup: group!, usersInvited: usersInvited) { (invitationComplete) in
            
            if invitationComplete {
                self.view.removeFromSuperview()
            }
            
        }
    }
    
  
    // buttons actions to turn selected and display accordingly
    
    @IBAction func currentGuestTabButtonPressed(_ sender: Any) {
        
        // Toggle Flag
        isCurrentGuestsButtonSelected = true
        
        saveButton.isHidden = true
        closeGuestMenuButton.isHidden = false
        
        // Empty array of users invited
        usersInvited = [User]()
        
        // Set Background color
        findNewGuestTabButton.tintColor = UIColor.gray
        // Change buttons appearence
        findNewGuestUnderlineUIView.backgroundColor = #colorLiteral(red: 0.5843137255, green: 0.5960784314, blue: 0.6039215686, alpha: 1)
        findNewGuestButtonHeightConstraint.constant = 2
        
        currentGuestUnderlineUIView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.5921568627, blue: 0.6509803922, alpha: 1)
        currentGuestButtonHeightConstraint.constant = 4
        
        // Hide suggested guests label
        suggestedGuestLabel.isHidden = true
        
        // Change textfield placeholder
        searchTextField.placeholder = "Find a Current Guest"
        searchTextField.setupView()
        
        // Set usersDisplayed to be currentGuests
        usersDisplayed = usersCurrentlyInGroup
        
        currentGuestTableView.reloadData()
    }
    
    @IBAction func findnNewGuestTabButtonPressed(_ sender: Any) {
        
        // Toggle Flag
        isCurrentGuestsButtonSelected = false
        
        
        // Set Background color
        currentGuestTabButton.tintColor = UIColor.gray
        
        // Change buttons appearence
        findNewGuestUnderlineUIView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.5921568627, blue: 0.6509803922, alpha: 1)
        findNewGuestButtonHeightConstraint.constant = 4
        
        currentGuestUnderlineUIView.backgroundColor = #colorLiteral(red: 0.5843137255, green: 0.5960784314, blue: 0.6039215686, alpha: 1)
        currentGuestButtonHeightConstraint.constant = 2
        
        // Show suggested guests label
        suggestedGuestLabel.isHidden = false
        
        // Change textfield placeholder
        searchTextField.placeholder = "Find a New Guest"
        searchTextField.setupView()
        
        // Set usersDisplayed to be currentGuests
        usersDisplayed = usersNotInGroup
        
        
        currentGuestTableView.reloadData()
    }
    
    @IBAction func closeGuestMenuButtonPressed(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    

    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isHidden = true
        closeGuestMenuButton.isHidden = false
        
        
        currentGuestTableView.delegate = self
        currentGuestTableView.dataSource = self
        
        suggestedGuestLabel.isHidden = true
        
        searchTextField.delegate = self
        
        // Add target whenever textfield changes
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // Load arrays
        
        DataService.instance.getAllUsersInGroup(group: group!) { (returnedUsersArray) in
            self.usersCurrentlyInGroup = returnedUsersArray
            self.usersDisplayed = self.usersCurrentlyInGroup
            
            self.currentGuestTableView.reloadData()
        }
        
        DataService.instance.getAllUsersNotInGroup(group: group!) { (returnedUsersArray) in
            self.usersNotInGroup = returnedUsersArray
        }
        
       
        usersDisplayed = usersCurrentlyInGroup
    }
    
   func initData(forGroup group: Group) {
        self.group = group
    }
    
    // Function to execute whenever textfield changes
    @objc func textFieldDidChange () {
        
        // if search query is empty show the array as empty
        if searchTextField.text == "" {
            
            if isCurrentGuestsButtonSelected {
                usersDisplayed = usersCurrentlyInGroup
            } else {
                usersDisplayed = usersNotInGroup
            }
            
            currentGuestTableView.reloadData()
            
        } else {
            
            // if there is a search in textfield start getting emails from database
            
            if isCurrentGuestsButtonSelected {
                
                DataService.instance.getUsers(forSearchQuery: searchTextField.text!, handler: { (returnedUsersArray) in
                    
                    var searchArray = returnedUsersArray
                    
                    
                    for user in self.usersNotInGroup {
                        
                        searchArray = searchArray.filter({ $0.uid != user.uid})
                        
                    }
                    
                    self.usersDisplayed = searchArray
                    self.currentGuestTableView.reloadData()
                    
                })
                
                
            } else {
                
                DataService.instance.getUsers(forSearchQuery: searchTextField.text!, handler: { (returnedUsersArray) in
                    
                    var searchArray = returnedUsersArray
                    
                    
                    for user in self.usersCurrentlyInGroup {
                        
                        searchArray = searchArray.filter({ $0.uid != user.uid})
                        
                    }
                    
                    self.usersDisplayed = searchArray
                    self.currentGuestTableView.reloadData()
                    
                })
                
                
            }
            
            
           
        }
        
    }
    
    // Tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersDisplayed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentMembersInGroupTableViewCell") as? CurrentMembersInGroupTableViewCell else {return UITableViewCell()}
        
            
        cell.configureCell(user: usersDisplayed[indexPath.row], isSelected: false, showCurrentGuests: isCurrentGuestsButtonSelected)
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CurrentMembersInGroupTableViewCell else {return}
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        

        if !isCurrentGuestsButtonSelected {

            // Toggle between invite and invited

            // If selected user is NOT in array of users invited
            if !usersInvited.contains(where: { $0.uid == cell.idLabel.text!}) {


                // Append user to invited array
                usersInvited.append(usersDisplayed[indexPath.row])

                print("user added to array: \(String(describing: usersInvited.last))")

                print("usersInvited count: \(usersInvited.count)")

                // Change label to Invited
                cell.inviteLabel.textColor = #colorLiteral(red: 0.9294117647, green: 0.568627451, blue: 0.2078431373, alpha: 1)
                cell.inviteLabel.text = "INVITED"

                // Toggle the buttons
                closeGuestMenuButton.isHidden = true
                saveButton.isHidden = false

            } else {
                // If user IS in array

                // Change label to Invite
                cell.inviteLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.662745098, blue: 0.7176470588, alpha: 1)
                cell.inviteLabel.text = "INVITE"

                // Remove it from the array of users invited
                usersInvited = usersInvited.filter({ $0.uid != cell.idLabel.text!})

               //  If array is empty show the skip button and hide save button
                if usersInvited.count == 0 {
                    closeGuestMenuButton.isHidden = false
                    saveButton.isHidden = true
                }
            }

        }
        
        
        
        
    }
}



