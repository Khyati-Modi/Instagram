//
//  MyTableViewCell.swift
//  Instagram
//
//  Created by Khyati Modi on 01/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase

class MyTableViewCell: UITableViewCell {
    var db = Firestore.firestore()
    
    @IBOutlet weak var headerView: UIView!
   
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    var deleteFlag : Int = 0
    var readData : [String] = []
    var newCaption : String = ""
    var pic1 = UIImage(named: "like-1.jpg")
    var pic2 = UIImage(named: "Like.jpg")
    

    @IBAction func likeButtonPressed(_ sender: UIButton) {
        Analytics.logEvent("PostLikeClicked", parameters :nil)
        if likeButton.currentImage == pic1{
        likeButton.setImage(pic2, for: .normal)
    }
    else{
        likeButton.setImage(pic1, for: .normal)
        }
       
    }
    @IBAction func editData(_ sender: UIButton) {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                self.newCaption = textField.text!
            }
            alert.addAction(action)
            alert.addTextField { (field) in
                textField = field
                textField.placeholder = "Add a new Category"
            }
        
        
        
        db.collection("createPost").getDocuments { (querySnapshots, err) in
            if let err = err {
                print("hellllllooooo ............. \(err.localizedDescription)")
            } else {
                for document in querySnapshots!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if document.data()["Caption"] as? String == self.captionLabel.text
                    {
                        self.db.collection("createPost").document(document.documentID).setValue(self.newCaption, forKey: "Caption")
                    }
                }
            }
        }
    }
    @IBAction func deletePost(_ sender: UIButton) {
        deleteFlag = 0
        if deleteFlag == 0
        {
            db.collection("createPost").getDocuments { (querySnapshots, err) in
                if let err = err {
                    print("hellllllooooo ............. \(err.localizedDescription)")
                } else {
                    for document in querySnapshots!.documents {
                        print("\(document.documentID) => \(document.data())")
                        if document.data()["Caption"] as? String == self.captionLabel.text
                        {
                            self.db.collection("createPost").document(document.documentID).delete()
                        }
                    }
                }

        }
        deleteFlag = 1
    }
        db.collection("createPost").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.readData.append(document.data()["Caption"] as! String)
                }
            }
//            self.tableView.reloadData()
        }
    }
    override func awakeFromNib() {
        profileButton.layer.cornerRadius = 20
        profileButton.clipsToBounds = true
        profileButton.backgroundColor = UIColor.blue
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
