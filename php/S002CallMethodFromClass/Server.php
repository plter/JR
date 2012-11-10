<?php
require_once 'com/plter/jr/server/JRServer.php';

class HelloClass{
	
	public function sayHello(){
		return 'Hello world';
	}
}


$server=new JRServer();
$server->addClass('HelloClass');
echo $server->handle();