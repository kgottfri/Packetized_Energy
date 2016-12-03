//
//  ViewController.swift
//  RemoteDBSwift
//
//  Created by Christian Skalka on 11/8/15.
//  Copyright © 2015 Christian Skalka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var getName: UITextField!
    
    @IBOutlet weak var getAge: UILabel!
    
    @IBOutlet weak var postName: UITextField!
    
    @IBOutlet weak var postAge: UITextField!
    
    @IBAction func getRefresh(_ sender: AnyObject) {
        
        let urlstr : String = "http://www.uvm.edu/~abeard1/Restful/example.php?name=" + getName.text!
        
        guard let url = URL(string: urlstr) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = NSMutableURLRequest(url: url)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue:OperationQueue.main, completionHandler: {
            (response, data, error) in
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET")
                print(error)
                return
            }
            
            let jo : NSDictionary
            do {
                jo =
                    try JSONSerialization.jsonObject(with: responseData, options: [])
                        as! NSDictionary
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
            if let age = jo["age"]
            {
                self.getAge.text = String(describing: age)
            }
        })

    }
    
    @IBAction func postRefresh(_ sender: AnyObject) {
        
        // playing fast and loose here, in practice should check non-emptiness of 
        // text fields, and possibly validate other expected properties of text.
        let urlstr : String =
            "http://www.uvm.edu/~abeard1/Restful/example.php?name="
            + postName.text!
            + "&age="
            + postAge.text!
        
        guard let url = URL(string: urlstr) else {
            print("Error: cannot create URL")
            return
        }
       
        let urlRequest = NSMutableURLRequest(url: url)  // must be mutable to set the http method
        urlRequest.httpMethod = "POST"
        
        NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue:OperationQueue.main, completionHandler: {
            (response, data, error) in
            
            guard let _ = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling POST")
                print(error)
                return
            }
            
            self.postAge.text = "posted"
            self.postName.text = "posted"
            
        })
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

