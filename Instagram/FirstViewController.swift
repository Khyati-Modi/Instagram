//
//  FirstViewController.swift
//  Instagram
//
//  Created by Khyati Modi on 01/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit



class FirstViewController: UIViewController,LoginButtonDelegate {

    
    
    @IBOutlet weak var subView: UIView!
    let loginButton = FBLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        loginButton.delegate = self
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y:502, width: view.frame.width - 32, height: 50)
        
        self.navigationController?.navigationBar.isHidden = true
        if UserDefaults.standard.bool(forKey: "LogIn") == true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
            navigationController?.pushViewController(vc, animated:false)
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
      
        if let error = error {
            print(error.localizedDescription)
            return
        }
        else{
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
            Analytics.logEvent("LoginButtonPressed", parameters: nil)
            UserDefaults.standard.set(true, forKey: "LogIn")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
            navigationController?.pushViewController(vc, animated:false)
            
        }
        
    }
    //no need of logon button here no call to this function
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        UserDefaults.standard.set(false, forKey: "LogIn")
        print("Logged out")
    }
    
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 85.0/255.0, green: 37.0/255.0, blue: 134.0/255.0, alpha: 0.7)
        let colorBottom = UIColor(red: 150.0/255.0, green: 20.0/255.0, blue: 255.0/255.0, alpha: 0.7)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:5)
    }
}
