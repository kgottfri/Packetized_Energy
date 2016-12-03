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
    var arrayX = [Int]()
    var arrayY = [Int]()
    
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
    @IBAction func resetButton(_ sender: AnyObject) {
        self.imageView.image = nil
        lastPoint = nil
        arrayX = []
        arrayY = []
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
                arrayX.append(x)
                arrayY.append(y)
//                inc = inc + 1
            }
            lastPoint = currentPoint
        }
        
    }
    
    //Function called if
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        //Called if the line drawn is ended.  the value of the x point should be greater than 600 
        // or the line will disappear.
        if(isSwiping == true){
            if(lastPoint.x < 600){
                self.imageView.image = nil
                lastPoint = nil
            }
        }
        // go here if only one point is drawn(should just clear the graph)
        else if(!isSwiping) {
            if(lastPoint.x < 600){
                self.imageView.image = nil
                lastPoint = nil
            }
        }
        
        
    }
    func message(message: String, segue: Bool){
        
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
    
//    func DrawData(_ ){
//        UIGraphicsBeginImageContext(self.imageView.frame.size)
//        
//        for count in 1...5{
//            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: (count - 1: float), y: (data[count-1]: float)))
//            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: count, y: data[count]))
//        }
//    }

}
