
//
//  ConnectViewController.swift
//  Packetized Energy Tablet App
//
//  Created by Alex Beard on 11/10/16.
//  Copyright © 2016 Packetized Energy. All rights reserved.
//
import UIKit

//global so it can be accessed from GraphViewController
var urlStr = " "

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
        
        let ip = self.ip_address.text
        let port = self.port_number.text
        //initialize connection (using inputted IP address and port number)
        urlStr = "http://" + ip! + ":" + port!
        //let urlStr : String = ip! + ":" + port!
        print(urlStr)
        let url = URL(string : urlStr)
        var request = URLRequest(url: url!)
        
//        //POST code (not working yet)
        request.httpMethod = "GET"
//        let postString = "THISISATEST"
//        request.httpBody = postString.data(using: .utf8)
        //let semaphore = DispatchSemaphore(value: 0)
        //get code (recieves "confirmed" from server):
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {   // check for fundamental networking error
                self.errorMessage(message: "Can not connect to " + urlStr, segue: false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            //semaphore.signal()
            self.serverConfirmation = String(data: data, encoding: .utf8)!
            
            //go to next screen if serverConfirmation = "confirmed"
            if self.serverConfirmation == "confirmed" {
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "ConnectSegue", sender: nil)
                }
                
            }
            else {
                

            }
            
                        
        }
        
        task.resume();
        
    }
    
    func errorMessage(message: String, segue: Bool){
        
        let alert = UIAlertController(title:"Alert", message: message, preferredStyle: UIAlertControllerStyle.alert )
        var okAction: UIAlertAction
        
        if segue {
            okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default,  handler: { action in self.performSegue(withIdentifier: "ConnectSegue", sender: self)} )
        }
        else{
            okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil)
        }
        
        alert.addAction(okAction)
        
        self.present(alert,animated: true,completion: nil)
        
        
        
    }
}


    


