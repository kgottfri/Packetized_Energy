//Lets require/import the HTTP module
var http = require('http');


//Lets define a port we want to listen to
const PORT=8080; 

//We need a function which handles requests and send response
function handleRequest(request, response){
  
    //console.log(request);

    if(request.method = "GET") {

	//console.log(request)
	console.log('get')
	response.end('confirmed');
    }

    if(request.method = "POST") {

	//console.log(request)
	
	console.log('post')
	console.log(request.data)
	response.end("post worked");

	request.on('data', function(chunk) {
	console.log("Received body data:");
	console.log(chunk.toString());
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
    
    
});
