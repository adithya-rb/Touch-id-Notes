//
//  MasterTableViewController.swift
//  Notes
//
//  Created by Adithya Bharadwaj on 26/10/15.
//  Copyright (c) 2015 Adithya Bharadwaj. All rights reserved.
//

import UIKit
import LocalAuthentication

class MasterTableViewController: UITableViewController, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate {

    
    var noteObjects : NSMutableArray! = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)


  
        
            }
    
    override func viewWillAppear(animated: Bool) {
        
        self.authenticateUser()

    }
    
    func fetchAllObjectsFromLocalDataStore(){
        
        let query : PFQuery = PFQuery(className: "Notes")
        query.fromLocalDatastore()
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(error == nil){
                let temp : NSArray = objects as! NSArray
                self.noteObjects = temp.mutableCopy() as! NSMutableArray
                self.tableView.reloadData()
            }
            else{
                print(error?.userInfo)
            }
        }
        
    }
    
    func fetchAllObjects(){
        
        //PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        let query : PFQuery = PFQuery(className: "Notes")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(error == nil){
                PFObject.pinAllInBackground(objects, block: nil)
                self.fetchAllObjectsFromLocalDataStore()
            }
            else{
                print(error?.userInfo)
            }
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if(!username.isEmpty || !password.isEmpty){
            return true
        }
        else{
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("Failed to Login")
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        /*if let password = info? ["password"] as? String{
            return password.utf16Count >=8
        }*/
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("Failed to SignUp")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        print("User Cancelled the SignUp")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.noteObjects.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MasterTableViewCell

        let object : PFObject = self.noteObjects.objectAtIndex(indexPath.row) as! PFObject
        cell.masterTitleLabel.text = object.objectForKey("title") as? String
        cell.masterTextLabel.text = object.objectForKey("text") as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("editNote", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let upcoming : AddNoteTableViewController = segue.destinationViewController as! AddNoteTableViewController
        if(segue.identifier == "editNote"){
            let indexPath = self.tableView.indexPathForSelectedRow
            let object : PFObject = self.noteObjects.objectAtIndex(indexPath!.row) as! PFObject
            upcoming.object = object
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
    }
    
    func parseLoginSetup(){
        

        if(PFUser.currentUser() == nil){
            let loginViewController = PFLogInViewController()
            loginViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton]
            let loginTitleLogo = UILabel()
            loginTitleLogo.text = "Adithya Bharadwaj"
            loginViewController.logInView?.logo = loginTitleLogo
            loginViewController.delegate = self
            
            
            let signupViewController = PFSignUpViewController()
            let signupTitleLogo = UILabel()
            signupTitleLogo.text = "Adithya Bharadwaj"
            signupViewController.signUpView?.logo = signupTitleLogo
            signupViewController.delegate = self
            
            loginViewController.signUpController = signupViewController
        
            
           self.presentViewController(loginViewController, animated: true, completion: nil)
            
            
        }
        else{
            self.fetchAllObjectsFromLocalDataStore()
            self.fetchAllObjects()
        }

        
    }
    
    @IBAction func buttonParseLogout(sender: AnyObject) {
    
    PFUser.logOut()
        self.parseLoginSetup()
    
    }
    
    
    func authenticateUser(){
        
        let context = LAContext()
        var error:NSError?
        let reasonstring = "Authentication is needed"
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonstring, reply: { (success, policyError) -> Void in
                if success{
                    print("Authentication successful")
                }
                else{
                    
                    switch policyError?.code{
                    case LAError.SystemCancel.rawValue? :
                        print("Cancelled by the system")
                    case LAError.UserCancel.rawValue? :
                        print("cancelled by user")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                           self.authenticateUser()
                        })
                    case LAError.UserFallback.rawValue? :
                        print("user selected to enter password")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.passwordAuthentication()
                        })
                    default :
                        print("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.passwordAuthentication()
                        })
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                }
            })
            
            
            
        }
        else
        {
            
            print(error?.localizedDescription)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.passwordAuthentication()
            })
            
            
            
        }
        
        
        
        
        
        
    }
    
    func passwordAuthentication(){
        
        let alertcontroller = UIAlertController(title: "Touch ID", message: "Enter Password to launch app", preferredStyle: UIAlertControllerStyle.Alert)
        let alertaction = UIAlertAction(title: "OK", style: .Cancel) { (ACTION) -> Void in
            if let textfield = alertcontroller.textFields?.first as UITextField!
            {
                if textfield.text == "adithya"
                {
                    print("authentication successful")
                    self.parseLoginSetup()
                }
                else
                {
                    self.passwordAuthentication()
                }
            }
        }
        alertcontroller.addAction(alertaction)
        alertcontroller.addTextFieldWithConfigurationHandler { (textfield) -> Void in
            textfield.placeholder = "password"
            textfield.secureTextEntry = true
        }
        
        //let startcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("alertcontroller") as UIViewController
        
        self.presentViewController(alertcontroller, animated: true, completion: nil)
        
      //self.transitionFromViewController(navigationController!, toViewController: alertcontroller, duration: 5.0, options: .TransitionNone, animations: nil, completion: nil)
  
        
        
        
    }
    

}
