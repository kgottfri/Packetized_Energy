//
//  GraphViewController.swift
//  Packetized Energy Tablet App
//
//  Created by Kevin Gottfried on 11/10/16.
//  Copyright © 2016 Packetized Energy. All rights reserved.
//

import UIKit
class GraphViewController: UIViewController {
    
    
    var lastPoint:CGPoint!
    var currentPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    let data = [2.3, 4.4, 5.6, 1.3, 2.2]
    let xScale = CGFloat(5)
    let yScale = CGFloat(6)
    var x = 0
    var y = 0
    var inc = 0
    var array = [[Int]]()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var Start: UIButton!
    @IBOutlet weak var tfField: UITextField!
    @IBOutlet weak var graphView: GraphViewController!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateChartWithData()
        // Do any additional setup after loading the view.
        red   = (0.0/255.0)
        green = (0.0/255.0)
        blue  = (0.0/255.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The reset button for the graph
    
    @IBAction func undoDrawing(_ sender: AnyObject) {
        self.imageView.image = nil
        lastPoint = nil
        
    }
    
    // Creates a data point when the user first touches the screen
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        isSwiping    = false
        if let touch = touches.first{
            lastPoint = touch.location(in: imageView)
            x = Int(lastPoint.x) / Int(xScale)
        }
    }
    
    //If the finger is still on the screen, the user will start to draw a line
    //The user will draw a continuous line in the x direction as long as
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        
        isSwiping = true;
        if let touch = touches.first{
            
            currentPoint = touch.location(in: imageView)
            if (currentPoint.x < lastPoint.x){
                currentPoint.x = lastPoint.x
            }
            UIGraphicsBeginImageContext(self.imageView.frame.size)
            self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
            UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.square)
            UIGraphicsGetCurrentContext()?.setLineWidth(2.0)
            UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            UIGraphicsGetCurrentContext()?.strokePath()
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if(lastPoint.x.truncatingRemainder(dividingBy: xScale) == 0){
                y = 600 - Int(lastPoint.y) * Int(yScale)
                array[inc] = [x, y]
                inc = inc + 1
            }
            lastPoint = currentPoint
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        if(!isSwiping) {
            if(currentPoint.x > 600){
            // This is a single touch, draw a point
            UIGraphicsBeginImageContext(self.imageView.frame.size)
            self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
            UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
            UIGraphicsGetCurrentContext()?.setLineWidth(2.0)
            UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.strokePath()
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            }
        }
    }
    
//    func DrawData(_ ){
//        UIGraphicsBeginImageContext(self.imageView.frame.size)
//        
//        for count in 1...5{
//            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: (count - 1: float), y: (data[count-1]: float)))
//            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: count, y: data[count]))
//        }
//    }

}
