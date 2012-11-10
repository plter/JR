<?php
require_once 'com/plter/jr/server/ValueObject.php';

/**
 * 
 * 此类为jr服务器，用于处理jr连接
 *
 */
class JRServer{
	
	private $functions=array();
	private $classes=array();
	private $vos=array();
	
	/**
	 * 添加一个函数
	 * @param string $functionName
	 */
	public function addFunction($functionName){
		$this->functions[$functionName]=$functionName;
	}
	
	/**
	 * 添加一个类
	 * @param string $className
	 */
	public function addClass($className){
		$this->classes[$className]=$className;
	}
	
	/**
	 * 注册一个值对象类
	 * @param string $className
	 */
	public function registerValueObject($className){
		$vo=new $className();
		if($vo instanceof ValueObject){
			$this->vos[$vo->alias]=$className;
		}
	}
	
	

	/**
	 * 处理客户端请求
	 * @return string
	 */
	public function handle(){
		$jsonObj=json_decode($_POST['method']);
		if(empty($jsonObj)){
			return 'JR(JSON Remote) server running...<br/>Powered by xtiqin,website:<a href="http://plter.com">http://plter.com</a>';
		}
		
		$op=explode('.',$jsonObj->name);
		$args=$jsonObj->args;
		$newArgs=array();
		
		foreach ($args as $key => $value) {
			if(!empty($value->alias)){
				array_push($newArgs, $this->convertValueObject($value));
			}else {
				array_push($newArgs, $value);
			}
		}
		
		switch (count($op)){
			case 1:
				$functionName=$op[0];
				$data->result=call_user_func_array($this->functions[$functionName], $newArgs);
				return json_encode($data);
				break;
			case 2:
				$className=$op[0];
				$functionName=$op[1];
				
				$data->result=call_user_func_array(array($this->classes[$className],$functionName), $newArgs);
				return json_encode($data);
				break;
		}
	}
	
	private function convertValueObject(&$vo){
			$voClass=$this->vos[$vo->alias];
			$returnVo=empty($voClass)?new ValueObject:new $voClass;
			$returnVo->alias=$vo->alias;
			
			foreach ($vo as $key => $value) {
				if (!empty($value->alias)){
					$value=$this->convertValueObject($value);
				}
				$returnVo->$key=$value;
			}
			return $returnVo;
	}
}