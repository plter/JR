package com.plter.jr.client
{
	import flash.net.URLLoader;
	
	
	/**
	 * AJP方法调用通道
	 */	
	public class JRChannel extends URLLoader
	{
		
		
		/**
		 * 构造一个AJP方法调用通道
		 * @param methodName 方法名称
		 * 
		 */		
		public function JRChannel(methodName:String)
		{
			super(null);
			
			this._id=JRChannel._id;
			JRChannel._id++;
			
			this._methodName=methodName;
		}
		
		private static var _id:int=0;
		
		private var _id:int=0;
		
		/**
		 * 取得当前调用通道的id
		 */
		public function get id():int
		{
			return _id;
		}
		
		private var _methodName:String="";
		
		/**
		 * 取得当前正在调用的方法名称
		 */
		public function get methodName():String{
			return _methodName;
		}
	}
}