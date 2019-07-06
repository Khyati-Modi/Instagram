//
//  SideBarTableViewController.swift
//  Instagram
//
//  Created by Khyati Modi on 03/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import  Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import MessageUI

class SideBarTableViewController: UITableViewController , MFMessageComposeViewControllerDelegate {
   
    
    
    let itemArray = ["Home","Share App","Logout"]
    let iconArray = [#imageLiteral(resourceName: "home"), #imageLiteral(resourceName: "Share App"), #imageLiteral(resourceName: "Logout")]
    let firebaseAuth = Auth.auth()

    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileName.text = Auth.auth().currentUser?.displayName
        let  url = Auth.auth().currentUser?.photoURL
        if let data = try? Data(contentsOf: url!){
            if let image = UIImage(data: data){
                profileButton.setImage(image, for: .normal)
            }
        profileButton.layer.cornerRadius = 100
        }
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return itemArray.count
    }
   

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        cell.imageView?.image = iconArray[indexPath.row]
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
        navigationController?.pushViewController(vc, animated:true)
        }
            
            
        else if indexPath.row == 1{
            
            let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
            
            let emailAction = UIAlertAction(title: "Share via Email", style: .default)
            
            let messageAction = UIAlertAction(title: "Share via Message", style: .default) { (action: UIAlertAction) in
                self.shareOnlyText()
            }
            let otherAction = UIAlertAction(title: "Share via Others", style: .default) { (action: UIAlertAction) in
                self.shareOther()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            optionMenu.addAction(emailAction)
            optionMenu.addAction(messageAction)
            optionMenu.addAction(otherAction)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
            
        }
        else if indexPath.row == 2 {
            do {
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().currentUser?.link(with:credential,completion:nil)
               //dont like this "try!" catch block will be unrechable so meaning of try keyword here
                try! Auth.auth().signOut()
                Auth.auth().signInAnonymously()
                LoginManager().logOut()
            }
           
            catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
           //user default is not required we can directly check which user is loged in or no user is loged in from firebase auth instance
            UserDefaults.standard.set(false, forKey: "LogIn")
            self.tabBarController?.navigationController?.popToRootViewController(animated: true)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as? FirstViewController
            navigationController?.pushViewController(vc!, animated: true)

            
            
            
        }
    }
    
    func shareOnlyText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "Enter a message";
            messageVC.recipients = ["Enter tel-nr"]
            messageVC.messageComposeDelegate = self
        self.tabBarController?.present(messageVC, animated: true, completion: nil)
        }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func shareOther(){
        let text = "This is the text...."
            let bounds = UIScreen.main.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
            self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let activityViewController = UIActivityViewController(activityItems: [img!, text], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        
    }
}

