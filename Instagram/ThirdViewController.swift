//
//  ThirdViewController.swift
//  Instagram
//
//  Created by Khyati Modi on 01/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase

class ThirdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Use Firebase library to configure APIs
    let storage = Storage.storage()
    var db: Firestore!
    var setId : String = ""
    
   
    
    @IBOutlet weak var postText: UITextView!
    
   
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postText.layer.borderWidth = 1
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        
        self.navigationController?.navigationBar.isHidden = true
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 00, y: 20, width: view.frame.size.width, height:50))
        navigationBar.backgroundColor = UIColor.white
        
        let navigationItem = UINavigationItem()
        navigationBar.items = [navigationItem]
        navigationItem.title = "Create Post"
        let leftButton =  UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ThirdViewController.leftbtnclicked(_:)))
        let rightButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(ThirdViewController.shareButtonClick(_:)))
        
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        self.view.addSubview(navigationBar)
        print("Shared")
    }
    @IBAction func uploadImage(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func shareButtonClick(_ sender: UIBarButtonItem) {
        addCaption()
        addImage()
        Analytics.logEvent("CreatePostClicked", parameters :nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddPostViewController") as!  AddPostViewController
        navigationController?.pushViewController(vc, animated:true)
    }
    
    @IBAction func leftbtnclicked(_ sender: UIBarButtonItem) {
        print("Cancel")
    }
    
    
    func addCaption() {
        let text = postText.text!
        var ref: DocumentReference? = nil
        let newItem = UserInfo()
        ref = db.collection("createPost").addDocument( data: ["Caption": "\(text)"]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
            
        }
        newItem.postId = ref!.documentID
        newItem.postCaption = text
     
        self.setId = ref!.documentID
        print("Document added with ID: \(ref!.documentID)")
        print(self.setId)
    }
    
    func addImage(){
        let imageID = setId
        let uploadRef = Storage.storage().reference(withPath: "uploads/\(imageID).jpg")
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "uploads/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetadata) { (uploadedMetadata, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else
            {
                print(uploadedMetadata!)
            }
        }
    }
}
