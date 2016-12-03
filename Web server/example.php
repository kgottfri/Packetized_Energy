<?php
  // example request: http://path/to/resource/Example?method=sayHello&name=World

  require_once "constants.php";
  require_once "pass.php";
  require_once "Database.php";
  
  //First, detect if we are receiving a GET request
  if($_SERVER['REQUEST_METHOD']=="GET")
  {	
	//extract the username from the header
	$name = $_GET['name'];
	
	//instantiate the database connection
	$dbUserName = get_current_user() . '_reader';
	$whichPass = "r"; //flag for which one to use.
	$dbName = DATABASE_NAME;
	$thisDatabaseReader = new Database($dbUserName, $whichPass, $dbName);
	
	//build our query
	$query = "select age from name_age where name = ?";
	$parameters = array($name);
	//execute the query on the database object
	$results = $thisDatabaseReader->select($query, $parameters, 1, 0, 0, 0, false, false);
	
	//extract the results and write them to a string for packaging to JSON
	$resultString = "";
	foreach($results as $val){
		$resultString = $resultString.$val[0];
	}
	echo json_encode(array('age' => $resultString));
  }
  //Otherwise, test if we are receiving a POST request
  elseif($_SERVER['REQUEST_METHOD']=="POST")
  {
	//extract the username and the age variable from the header
	$name = $_GET["name"];
	$age = $_GET["age"];
	//create the database writerObject
	$dbUserName = get_current_user() . '_writer';
	$whichPass = "w"; //flag for which one to use.
	$dbName = DATABASE_NAME;
	$thisDatabaseWriter = new Database($dbUserName, $whichPass, $dbName);
	
	//build and execute the query
	$query = "INSERT INTO `name_age`(`name`, `age`) VALUES (?, ?)";
	$parameters = array($name, $age);
	$result = $thisDatabaseWriter->insert($query, $parameters, 0,0,0,0,false,false);
	
	header( 'HTTP/1.1 201: Resource Created' );	
  }
  else{
	header('HTTP/1.1 501: NOT SUPPORTED');
  }
?>