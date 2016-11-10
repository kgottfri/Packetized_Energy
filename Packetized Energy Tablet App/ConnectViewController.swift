//
//  ConnectViewController.swift
//  Packetized Energy Tablet App
//
//  Created by Alex Beard on 11/10/16.
//  Copyright © 2016 Packetized Energy. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {
    
    @IBOutlet weak var port_number: UITextField!
    @IBOutlet weak var ip_address: UITextField!
    
    var serverConfirmation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConnectButtonPressed(_ sender: Any) {
        
        //initialize connection (using inputted IP address and port number)
        var request = URLRequest(url: URL(string: "http://" + ip_address.text! + ":" + port_number.text!)!)
        
        
        //POST code (not working yet)
        request.httpMethod = "POST"
        let postString = "THISISATEST"
        request.httpBody = postString.data(using: .utf8)
        
        //get code (recieves "confirmed" from server):
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {   // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            self.serverConfirmation = String(data: data, encoding: .utf8)!
            
            //go to next screen if serverConfirmation = "confirmed"
            if self.serverConfirmation == "confirmed" {
                
                self.performSegue(withIdentifier: "ConnectSegue", sender: nil)
            }
            
            
            //print("responseString = \(responseString!)")
            
        }
        
        task.resume();
        
    }
    

}
    


