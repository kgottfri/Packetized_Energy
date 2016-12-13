//Lets require/import the HTTP module
var http = require('http');

var dataArray = new Array();
var sendArray = new Array();
var count = 4;


//Lets define a port we want to listen to
const PORT=8080;

//We need a function which handles requests and send response
function handleRequest(request, response){
    
    
    if(request.method === 'GET') {
        
        //console.log(request)
        console.log('get')
        response.end('confirmed');
    }
    
    if(request.method === 'POST') {
        
        //console.log(request)
        
        console.log('post')
        console.log(request.data)
        //response.end('post worked ');
        
        request.on('data', function(chunk) {
                   console.log("Received body data:");
                   const data = chunk.toString();
                   console.log(data);
                   
                   //If End of Data: send back array to test
                   if (data.substring(data.length - 7) ==='DATAEND') {
                   
                   console.log("recognized end of data");
                   
                   dataArray = data.split(",");
                   dataArray.splice(0,(dataArray.length/2)+1);
                   dataArray.pop();
                   dataArray=dataArray.map(Number);
                   
                   for (i = 0; i < dataArray.length ; i++)
                   {
                   var rand = (Math.random() -  1)*7;
                   dataArray[i]=dataArray[i]+rand;
                   dataArray[i]=dataArray[i].toFixed(2);
                   
                   }
                   
                   
                   //console.log(dataArray);
                   
                   
                   }

	if (data === ‘RESET’) {

	console.log(‘reset command recieved’);

}
                   
                   else {
                   //response.end(data[parseInt(data, 10)]);
                   for (i = 0; i < count ; i++){
                   sendArray[i]=dataArray[i];
                   
                   }
                   sendArray=sendArray.toString();
                   //console.log(sendArray);
                   response.end(sendArray);
                   count++;
                   
                   //response.end("int parameter recieved");
                   }

    		


                   
                   
                   
                   });
        
    }
    
    
}


//Create a server
var server = http.createServer(handleRequest);

//Lets start our server
server.listen(PORT, function(){
              //Callback triggered when server is successfully listening. Hurray!
              console.log(server.address());
              console.log("Server listening on: http://localhost:%s", PORT);
              console.log(server.address().address);
              
              
              
              });

