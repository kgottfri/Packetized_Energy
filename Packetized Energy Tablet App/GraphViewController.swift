//  Packetized Energy Tablet App
//
//  Created by Kevin Gottfried on 11/10/16.
//  Copyright © 2016 Packetized Energy. All rights reserved.
//



import UIKit
class GraphViewController: UIViewController {
    
    //urlStr is url to connect to
    
    var lastPoint:CGPoint!
    var lastPointGet:CGPoint!
    var currentPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    let data = [2.3, 4.4, 5.6, 1.3, 2.2]
    let newX: [Float] = [1,2,5,6,7,10,15,20,50,100,120,170]
    let newY: [Float] = [44,55,36,37,50,66,74,66,56,57,51,44]
    let xScale = CGFloat(5)
    let yScale = CGFloat(6)
    var x: Float = 0
    var y: Float = 0
    var inc = 0
    var arrayX = [Float]()
    var arrayY = [Float]()
    var drawn = false
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var Start: UIButton!
    @IBOutlet weak var tfField: UITextField!
    @IBOutlet weak var graphView: GraphViewController!
    
    
    //use this message function to create a dialog box when necessary
    //message: the message to be displayed in the box
    //segue: flag whether or not the action will call a function
    //toSegue: the desired action to segue to.  can be function, UIViewController, or ""
    //title: desired title for the message box
    //cancel: do you want a cancel button on the dialog box
    func message(message: String, segue: Bool, toSegue: String, title: String, cancel: Bool){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert )
        var okAction: UIAlertAction
        var cancelAction: UIAlertAction

        if segue { //
            switch toSegue{ //switches the desired segue to function
            case "get()":
                okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default,  handler: { action in self.get()} )
            case "reset()":
                okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default,  handler: { action in self.reset()} )
            default:
                okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default,  handler: nil )
            }
            
        }
        else{
            okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil)
        }
        // if cancel bool is true then does nothing if button pressed,
        // if cancel is false, doesn't add a cancel option only "OK"
        if cancel {
            cancelAction = UIAlertAction(title:"Cancel", style: UIAlertActionStyle.default,  handler: nil )
            alert.addAction(cancelAction)
                
        }
        
        alert.addAction(okAction)
        
        self.present(alert,animated: true,completion: nil)
        
        
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //message(message: "Please Draw A Valid Line", segue: false, toSegue: "", title: "Info", cancel: false)
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
        message(message: "Are you sure you want to reset your drawing?", segue: true, toSegue: "reset()", title: "Reset Drawing", cancel: true)
    }
    // Calls the function to draw the second line labeled "done"
    @IBAction func Send(_ sender: AnyObject) {
        if(arrayX.isEmpty && arrayY.isEmpty){
            message(message: "Please Submit A valid drawing.", segue: false, toSegue: "", title: "Invalid Drawing", cancel: false)
        }
        else{
            message(message: "Are you sure you want to submit this drawing?", segue: true, toSegue: "get()", title: "Submit Drawing", cancel: true)
        }
            
    }
    
    // Creates a data point when the user first touches the screen
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        isSwiping    = false
        if let touch = touches.first{
            lastPoint = touch.location(in: imageView)
            x = Float(lastPoint.x) / Float(xScale)
            y = 100 - Float(lastPoint.y) / Float(yScale)
            arrayX.append(x)
            arrayY.append(y)
        }
    }
    
    //If the finger is still on the screen, the user will start to draw a line
    //The user will draw a continuous line in the x direction as long as they move forward
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        
        isSwiping = true;
        if(!drawn){
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
            UIGraphicsGetCurrentContext()?.setLineWidth(4.0)
            UIGraphicsGetCurrentContext()?.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            UIGraphicsGetCurrentContext()?.strokePath()
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            x = Float(lastPoint.x) / Float(xScale)
            y = 100 - Float(lastPoint.y) / Float(yScale)
                arrayX.append(x)
                arrayY.append(y)
            
            lastPoint = currentPoint
        }
        }
    }
    //Function called if
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        //Called if the line drawn is ended.  the value of the x point should be greater than 600 
        // or the line will disappear.
        if(isSwiping == true){
            if(lastPoint.x < 600){
                message(message: "Please draw a valid line.", segue: false, toSegue: "", title: "Valid", cancel: false)
                clear_screen()
            }
         
//            else {
//                //valid line drawn
//
//                print("upload_request called")
////                get()
//            }
        }
        // go here if only one point is drawn(should just clear the graph)
        else if(!isSwiping) {
            if(lastPoint.x < 600){
                clear_screen()
            }
        }
        
        
    }
    
    //loop to draw the second line
    func get(){
        upload_request()
        print (lastPoint)
        lastPointGet = lastPoint //funky way of initializing the first point
        lastPointGet.x = CGFloat(arrayX[0]) // funky way of updating first x point (can be changed)
        for index in 1..<newX.count{
            draw(x: newX[index],y: newY[index])
        }
    }
    
    // function to draw the second line with data from the newX and newY arrays defined globally
    // will draw the same line every time
    func draw(x: Float, y: Float){
//        = 600 + Int(lastPointGet.y) * Int(yScale)
        let nx = CGFloat(x * Float(xScale))
        let ny = CGFloat(y * Float(yScale))
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPointGet.x, y: lastPointGet.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: nx, y: ny))
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.square)
        UIGraphicsGetCurrentContext()?.setLineWidth(4.0)
        UIGraphicsGetCurrentContext()?.setStrokeColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        UIGraphicsGetCurrentContext()?.strokePath()
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        lastPointGet.x = CGFloat(x * Float(xScale))
        lastPointGet.y = CGFloat(y * Float(yScale))
    }

    func reset() {
        
        clear_screen()
        
        //send reset command
        var request = URLRequest(url: URL(string : urlStr)!)
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.uploadTask(with: request, from: "RESET".data(using: String.Encoding.utf8)) { data, response, error in
            guard let data = data, error == nil else {   // check for fundamental networking error
                print("Can not connect to the server")
                return
            }
            
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
        }
        
        task.resume()
        
    }
    
    func clear_screen() {
        self.imageView.image = nil
        lastPoint = nil
        arrayX.removeAll()
        arrayY.removeAll()
        
        //-------
//        var request = URLRequest(url: URL(string : urlStr)!)
//        
//        request.httpMethod = "POST"
//        
//        let task = URLSession.shared.uploadTask(with: request, from: "1".data(using: String.Encoding.utf8)) { data, response, error in
//            guard let data = data, error == nil else {   // check for fundamental networking error
//                print("Can not connect to the server")
//                return
//            }
//            
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            
//        }
//        
//        task.resume()
        
        
        //-------
    
    }
    
    func upload_request()
    {

        var request = URLRequest(url: URL(string : urlStr)!)
        
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
