package com.plter.jr.client
{
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	[Event(name="jrFault",type="com.plter.jr.client.JRServerEvent")]
	[Event(name="jrResult",type="com.plter.jr.client.JRServerEvent")]
	
	/**
	 * 此类封装了与ajp服务器通信的操作
	 * @author xtiqin
	 */
	public dynamic class JRServer extends Proxy implements IEventDispatcher
	{
		
		private var _channel:JRChannel;
		
		
		
		/**
		 * 构造一个JSONServer对象
		 * @param url	服务器的通信地址
		 * 
		 */
		public function JRServer(url:String="")
		{
			super();
			
			_dispatcher=new EventDispatcher(this);
			
			this.url=url;
		}
		
		private var _dispatcher:EventDispatcher;
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_dispatcher.removeEventListener(type,listener,useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
		
		private var _url:String="";

		
		/**
		 * 取得或者设置与服务器的通信地址
		 */
		public function get url():String
		{
			return _url;
		}

		
		/**
		 * 取得或者设置与服务器的通信地址
		 * @param value
		 */
		public function set url(value:String):void
		{
			_url = value;
		}

		
		/**
		 * 呼叫服务器的方法 
		 * @param methodName 方法名称
		 * @param args       参数列表
		 * @return JSONChannel
		 * 
		 */
		public function call(methodName:String,...args):JRChannel{
			
			_channel=new JRChannel(methodName);
			_channel.dataFormat=URLLoaderDataFormat.TEXT;
			_channel.addEventListener(Event.COMPLETE,_ul_eventHandler);
			_channel.addEventListener(IOErrorEvent.IO_ERROR,_ul_eventHandler);
			_channel.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_ul_eventHandler);
			
			var req:URLRequest=new URLRequest(url);
			
			req.method=URLRequestMethod.POST;
			req.data="method="+JSON.stringify({name:methodName,args:args});
			
			_channel.load(req);
			return _channel;
		}
		
		private var _vos:Object={};
		
		
		/**
		 * 注册一个值对象
		 * @param voRef
		 * 
		 */
		public function registerValueObject(voRef:Class):void{
			var vo:ValueObject=new voRef;
			if(vo!=null){
				_vos[vo.alias]=voRef;
			}else{
				throw new TypeError("Argument \"voRef\" must be ValueObject");
			}
		}
		
		override flash_proxy function callProperty(name:*, ...parameters):*{
			parameters.splice(0,0,name);
			return call.apply(null,parameters);
		}
		
		override flash_proxy function getProperty(name:*):*{
			return new AJPServerOperation(name,call);
		}
		
		protected function _ul_eventHandler(event:Event):void{
			
			var channel:JRChannel=event.target as JRChannel;
			channel.removeEventListener(Event.COMPLETE,_ul_eventHandler);
			channel.removeEventListener(IOErrorEvent.IO_ERROR,_ul_eventHandler);
			channel.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,_ul_eventHandler);
			
			switch(event.type){
				case Event.COMPLETE:
					try{
						var jsonObj:Object=JSON.parse(channel.data);
						var resultObj:Object=jsonObj.result;
						if(resultObj.hasOwnProperty("alias")){
							resultObj=convertValueObject(resultObj);
						}
						
						dispatchEvent(new JRServerEvent(JRServerEvent.JR_RESULT,channel,resultObj));
					}catch(error:Error){
						dispatchEvent(new JRServerEvent(JRServerEvent.JR_FAULT,channel,null,"无效的JSON数据格式"));
					}
					break;
				case IOErrorEvent.IO_ERROR:
				case SecurityErrorEvent.SECURITY_ERROR:
					var errorEvent:ErrorEvent=event as ErrorEvent;
					dispatchEvent(new JRServerEvent(JRServerEvent.JR_FAULT,channel,null,errorEvent.text));
					break;
			}
		}
		
		private function convertValueObject(vo:Object):Object{
			var voClass:Class=_vos[vo.alias];
			var returnVo:ValueObject=voClass==null?new ValueObject:new voClass;
			returnVo.alias=vo.alias;
			
			for(var k:String in vo){
				if(vo[k]!=null&&vo[k].hasOwnProperty("alias")){
					vo[k]=convertValueObject(vo[k]);
				}
				returnVo[k]=vo[k];
			}
			return returnVo;
		}
	}
}



import flash.utils.Proxy;
import flash.utils.flash_proxy;

class AJPServerOperation extends Proxy{
	
	
	private var _operationName:String="";
	private var _call:Function;
	
	public function AJPServerOperation(operationName:String,call:Function):void{
		this._operationName=operationName;
		this._call=call;
	}
	
	override flash_proxy function callProperty(name:*, ...parameters):*{
		if(_call!=null){
			parameters.splice(0,0,_operationName+"."+name);
			return _call.apply(null,parameters);
		}
		return null;
	}
}