//  Packetized Energy Tablet App
//
//  Created by Kevin Gottfried on 11/10/16.
//  Copyright © 2016 Packetized Energy. All rights reserved.
//

import UIKit
class GraphViewController: UIViewController {
    
    var url_to_request = "127.0.0.1:8080"
    var lastPoint:CGPoint!
    var lastPointGet:CGPoint!
    var currentPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    let data = [2.3, 4.4, 5.6, 1.3, 2.2]
    let newX: [Int] = [1,2,5,6,7,10,15,20,50,100,120,170]
    let newY: [Int] = [44,55,36,37,50,66,74,66,56,57,51,44]
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
    
    override func viewDidLoad() {
//        self.message(message: "Please draw a line starting in the left most grey area and continue to the right most grey area.", segue: false)
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
        arrayX.removeAll()
        arrayY.removeAll()
    }
    // Calls the function to draw the second line labeled "done"
    @IBAction func Send(_ sender: AnyObject) {
        get()
    }
    
    // Creates a data point when the user first touches the screen
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        isSwiping    = false
        if let touch = touches.first{
            lastPoint = touch.location(in: imageView)
            x = Int(lastPoint.x) / Int(xScale)
            y = 100 - Int(lastPoint.y) / Int(yScale)
            arrayX.append(x)
            arrayY.append(y)
        }
    }
    
    //If the finger is still on the screen, the user will start to draw a line
    //The user will draw a continuous line in the x direction as long as they move forward
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        
        isSwiping = true;
        if let touch = touches.first{
            
            currentPoint = touch.location(in: imageView)
            if (currentPoint.x < lastPoint.x){
                isSwiping = false
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
                x = Int(lastPoint.x) / Int(xScale)
                y = 100 - Int(lastPoint.y) / Int(yScale)
                arrayX.append(x)
                arrayY.append(y)
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
                arrayX.removeAll()
                arrayY.removeAll()
            }
         
            else {
                //valid line drawn
                upload_request()
                print("upload_request called")
//                get()
            }
        }
        // go here if only one point is drawn(should just clear the graph)
        else if(!isSwiping) {
            if(lastPoint.x < 600){
                self.imageView.image = nil
                lastPoint = nil
                arrayX.removeAll()
                arrayY.removeAll()
            }
        }
        
        
    }
    
    //loop to draw the second line
    func get(){
        print (lastPoint)
        lastPointGet = lastPoint //funky way of initializing the first point
        lastPointGet.x = CGFloat(arrayX[0]) // funky way of updating first x point (can be changed)
        for index in 1..<newX.count{
            draw(x: newX[index],y: newY[index])
        }
    }
    
    // function to draw the second line with data from the newX and newY arrays defined globally
    // will draw the same line every time
    func draw(x: Int, y: Int){
//        = 600 + Int(lastPointGet.y) * Int(yScale)
        let nx = x * Int(xScale)
        let ny = y * Int(yScale)
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPointGet.x, y: lastPointGet.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: nx, y: ny))
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.square)
        UIGraphicsGetCurrentContext()?.setLineWidth(2.0)
        UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        UIGraphicsGetCurrentContext()?.strokePath()
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        lastPointGet.x = CGFloat(x * Int(xScale))
        lastPointGet.y = CGFloat(y * Int(yScale))
    }

    
    func upload_request()
    {

        
        let url = URL(string : "http://127.0.0.1:8080")
        var request = URLRequest(url: url!)
        
        //        //POST code (not working yet)
                request.httpMethod = "POST"
        
                //let postString = "THISISATEST"
                //request.httpBody = postString.data(using: .utf8)
        //var post_data = .data(using: Int.Encoding.utf8)
        
        //convert to delimited strings for posting
        var arrayXstring = arrayX.map {
            String($0)
        }
        
        let arrayXpost = arrayXstring.joined(separator: ",")
        
        var arrayYstring = arrayY.map {
            String($0)
        }
        
        let arrayYpost = arrayYstring.joined(separator: ",")
        
        //combine
        let arraysPost = "X-VALUES: " + arrayXpost + " Y-VALUES: " + arrayYpost + "DATAEND"
        
        print(arraysPost)
        
        let post_data = arraysPost.data(using: String.Encoding.utf8)
        //let post_data = NSData(bytes: &test, length: MemoryLayout<Int>.size)
        
        //var data = "TESTDATA"
        //get code (recieves "confirmed" from server):
        let task = URLSession.shared.uploadTask(with: request, from: post_data) { data, response, error in
            guard let data = data, error == nil else {   // check for fundamental networking error
                print("Can not connect to the server")
                return
            }
            
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            var responseString = String(data: data, encoding: .utf8)!
            //should be test array from server - NOT WORKING
            print(responseString)
                
        }
        
        task.resume()

        
        
        
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
