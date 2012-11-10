<?php
require_once 'com/plter/jr/server/JRServer.php';

$server=new JRServer();
$server->addFunction('hello');
echo $server->handle();

function hello($name){
	return 'Hello '.$name;
}