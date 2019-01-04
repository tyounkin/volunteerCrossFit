//
//  SettingsViewController.swift
//  VCF
//
//  Created by Timothy Younkin on 1/4/19.
//  Copyright © 2019 Timothy Younkin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    //URL to our web service
    let URL_SAVE_TEAM = "http:www.volcrossfit.com/MyWebService/api/createteam.php"
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
//        //created NSURL
//        let requestURL = NSURL(string: URL_SAVE_TEAM)
        
        //creating NSMutableURLRequest
        let url = URL(string: URL_SAVE_TEAM)
        
//        //setting the method to post
//        request.HTTPMethod = "POST"
        
        //getting values from text fields
        let teamName = usernameTextField.text ?? "Default name"
        let memberCount = passwordTextField.text ?? "10"
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "name="+teamName+"&member="+memberCount;
        
        //adding the parameters to request body
        //request.HTTPBody = postParameters.dataUsingEncoding(NSUTF8StringEncoding)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
//        request.addValue("name",forHTTPHeaderField: teamName)
//        request.addValue("member",forHTTPHeaderField: memberCount)
        request.httpBody = postParameters.data(using: .utf8)
//        request.httpBody = data
//        HTTPsendRequest(request: request)
        print(request)
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("error is \(error)")
                return;
            }
            print(data)
            print(response)
            //parsing the response
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                print(myJSON)
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    
                    //printing the response
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
