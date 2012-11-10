package com.plter.jr.client
{
	import flash.events.Event;
	
	public class JRServerEvent extends Event
	{
		
		public static const JR_FAULT:String="jrFault";
		
		public static const JR_RESULT:String="jrResult";
		
		private var _result:Object;

		/**
		 * 取得服务器的返回值 
		 * @return 
		 */		
		public function get result():Object
		{
			return _result;
		}
		
		private var _errorMsg:String="";

		/**
		 * 取得错误信息 
		 * @return 
		 * 
		 */		
		public function get errorMsg():String
		{
			return _errorMsg;
		}
		
		private var _channel:JRChannel;

		/**
		 * 取得方法调用通道 
		 * @return 
		 * 
		 */		
		public function get channel():JRChannel
		{
			return _channel;
		}

		
		public function JRServerEvent(type:String,channel:JRChannel=null,result:Object=null,errorMsg:String="")
		{
			super(type, false,false);
			this._result=result;
			this._errorMsg=errorMsg;
			this._channel=channel;
		}
		
		override public function clone():Event{
			return new JRServerEvent(type,channel,result,errorMsg);
		}
		
		override public function toString():String{
			return formatToString("JRServerEvent","type","channel","result","errorMsg");
		}
	}
}