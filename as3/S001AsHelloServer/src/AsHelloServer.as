package
{
	import com.plter.jr.client.JRServer;
	import com.plter.jr.client.JRServerEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class AsHelloServer extends Sprite
	{
		
		private var url:String="http://localhost:8080/S001HelloServer/index.jsp";
		private var server:JRServer;
		private var outTxt:TextField;
		
		public function AsHelloServer()
		{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			
			outTxt=new TextField;
			outTxt.width=stage.stageWidth-20;
			outTxt.height=stage.stageHeight-20;
			outTxt.x=10;
			outTxt.y=10;
			outTxt.border=true;
			outTxt.multiline=true;
			outTxt.wordWrap=true;
			addChild(outTxt);
			appendLine("Please click stage...");
			
			
			server=new JRServer;
			server.url=url;
			server.addEventListener(JRServerEvent.JR_FAULT,server_faultHandler);
			server.addEventListener(JRServerEvent.JR_RESULT,server_resultHandler);
			
			stage.addEventListener(MouseEvent.CLICK,stage_clickHandler);
		}
		
		private function server_faultHandler(event:JRServerEvent):void{
			appendLine(event.toString());
		}
		
		private function server_resultHandler(event:JRServerEvent):void{
			appendLine(String(event.result));
		}
		
		private function stage_clickHandler(event:MouseEvent):void{
			server.hello("plter");
		}
		
		private function appendLine(value:String):void{
			outTxt.appendText(value+"\n");
			outTxt.scrollV=outTxt.maxScrollV;
		}
	}
}