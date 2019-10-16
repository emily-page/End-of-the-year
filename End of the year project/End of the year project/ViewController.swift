//
//  ViewController.swift
//  End of the year project
//
//  Created by apcs2 on 5/15/18.
//  Copyright © 2018 apcs2. All rights reserved.
//
// https ://www.youtube.com/watch?v=qNqD-YJZV2M

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    @IBAction func signInButtonTapped(_ sender: Any)
    {
        print("Sign in button tapped")
        
        let userName = userNameTextField.text
        let userPassword = passwordTextField.text
        if (userName?.isEmpty)! || (userPassword?.isEmpty)!
        {
            print("Username \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            displayMessage(userMessage: "One of the fields is missing")
            return
        }
        
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        let myUrl = URL(string: "http://localhost:8080/api/authentication")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postString = ["userName": userName!, "userPassword": userPassword!] as [String: String]
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }
        catch let error
        {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong...")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request)
        {
            (data: Data?, response: URLResponse?, error: Error?) in
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            if error != nil
            {
                self.displayMessage(userMessage: "Could not preform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json
                {
                    let accessToken = parseJSON["token"] as? String
                    let uderId = parseJSON["id"] as? String
                    print("Access token: \(String(describing: accessToken!))")
                    
                    if (accessToken?.isEmpty)!
                    {
                        self.displayMessage(userMessage: "Didnt work try later")
                        return
                    }
//                    DispatchQueue.main.async {
//                        let homePage = self.storyboard?.instantiateInitialViewController(performSegue(withIdentifier: "HomeViewController" as! HomeViewController))
//                        let appDelegate = UIApplication.shared.delegate
//                        appDelegate?.window??.rootViewController = homePage
//                    }
                    
                }
            }
            catch
            {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessage(userMessage: "Culd not preform taskk")
                print(error)
            }
            
            }
        task.resume()
    }
 
    @IBAction func registerNewAccountButtonTapped(_ sender: Any)
    {
        print("Register account button tapped")
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        self.present(registerViewController, animated: true)
    }
    
    func displayMessage(userMessage: String) -> Void
    {
        DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                print("Ok button tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
}
