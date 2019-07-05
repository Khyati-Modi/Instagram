//
//  GestureViewController.swift
//  Instagram
//
//  Created by Khyati Modi on 05/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit

class GestureViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    var image : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector(("longPressed:")))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, Selector(("image:didFinishSavingWithError:contextInfo:")), nil)
    
        print("longpressed")
        
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if recognizer.state == .ended{
            imageView.center = self.view.center
        }
    }
    
 @IBAction func handlePinch(recognizer: UIPinchGestureRecognizer) {
    if let view = recognizer.view {
        view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
    }
    }
    @IBAction func handleRotate(recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    @IBAction func handleLongPress(recognizer : UILongPressGestureRecognizer) {
        recognizer.minimumPressDuration = TimeInterval(exactly: 3)!
        UIPasteboard.general.image = imageView.image
        print("Copied")
        let alert = UIAlertController(title: "Copied To Clipboard", message: "", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        var time = 3
        while time >= 0 {
            time = time - 1
            if time == 0 {
                dismiss(animated: true, completion: nil)
                break
            }
        }

    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated:true)
    }
    
    
   
}
