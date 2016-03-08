//
//  AddNoteTableViewController.swift
//  Notes
//
//  Created by Adithya Bharadwaj on 26/10/15.
//  Copyright (c) 2015 Adithya Bharadwaj. All rights reserved.
//

import UIKit

class AddNoteTableViewController: UITableViewController {
    @IBOutlet weak var titleLabel: UITextField!

    @IBOutlet weak var shareNote: UIBarButtonItem!
    @IBOutlet weak var textLabel: UITextView!
    var object : PFObject!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.object != nil){
            self.titleLabel.text = self.object.objectForKey("title") as? String
            self.textLabel.text = self.object.objectForKey("text") as? String
        }
        else{
            self.object = PFObject(className: "Notes")
        }
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    @IBAction func saveAction(sender: UIBarButtonItem) {
    
        let userNameString : String = PFUser.currentUser()!.username!
        let userTitleLabel : String = self.titleLabel.text!
        let userTextLabel : String = self.textLabel.text
        
        self.object.setObject(userNameString, forKey: "username")
        self.object.setObject(userTitleLabel, forKey: "title")
        self.object.setObject(userTextLabel, forKey: "text")
        //self.object.setObject("username") = PFUser.currentUser()?.username
        //self.object.objectForKey("title") = self.titleLabel.text
        //self.object.objectForKey("text") = self.textLabel.text
        
        self.object.saveEventually { (success, error) -> Void in
            if(error == nil){
                
            }
            else{
                print(error?.userInfo)
            }

        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)

        
        
    }
    
    
    @IBAction func shareNotesBtnClicked(sender: AnyObject) {
        //var shareText = "Hi"
        //var share:UIActivityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        var alert = UIAlertController(title: "Alert", message: "Choose from", preferredStyle: UIAlertControllerStyle.ActionSheet)
        var action1 = UIAlertAction(title: "one", style: .Default, handler: nil)
        var action2 = UIAlertAction(title: "two", style: .Default, handler: nil)
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
