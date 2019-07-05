//
//  SecondViewController.swift
//  Instagram
//
//  Created by Khyati Modi on 01/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase
import SideMenu


class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var db: Firestore!
    var itemArray = [UserInfo]()
    var readData : [String] = []
    var activityIndicator = UIActivityIndicatorView()
    

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = ["Khyati", "Dharmik", "Saheb",  "Kishan", "Milan"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyTableViewCell")
    }
    
  
    func getData(){
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        db.collection("createPost").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                self.activityIndicator.center = self.view.center
                self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.style = UIActivityIndicatorView.Style.gray
                self.view.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()
                
                for document in querySnapshot!.documents {
                    
                    let newItem = UserInfo()
                    newItem.postCaption = document.data()["Caption"] as! String
                    
                    print("\(document.documentID) => \(document.data())")
                    let storageRef = Storage.storage().reference(withPath: "uploads/\(document.documentID).jpg")
                    storageRef.getData(maxSize: 4 * 1024 * 1024){(data, error) in
                        if let error = error {
                            print("\(error)")
                            return
                        }
                        if let data = data {
                            newItem.postImage = UIImage(data: data)!
                            print("File Downloaded")
                        }
                        self.itemArray.append(newItem)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        getData()
        self.tableView.reloadData()
    }
    
    @IBAction func profileButton(_ sender: UIBarButtonItem) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        cell.captionLabel.text = itemArray[indexPath.row].postCaption
        cell.imageview.image = itemArray[indexPath.row].postImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GestureViewController") as!  GestureViewController
      vc.image = itemArray[indexPath.row].postImage
        navigationController?.pushViewController(vc, animated:true)
    }

}

extension SecondViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellReuse", for: indexPath as IndexPath)
        
        cell.layer.cornerRadius = 25
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
}

