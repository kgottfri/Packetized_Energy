//
//  ViewController.swift
//  Packetized Energy Tablet App
//
//  Created by Kevin Gottfried on 10/16/16.
//  Copyright © 2016 Packetized Energy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
                // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func errorMessage(message: String){
        
        let alert = UIAlertController(title:"Alert", message: message, preferredStyle: UIAlertControllerStyle.alert )
        var okAction: UIAlertAction
        
        okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil)
        
        alert.addAction(okAction)
        
        self.present(alert,animated: true,completion: nil)
        
        
        
    }
    
    
 


}

