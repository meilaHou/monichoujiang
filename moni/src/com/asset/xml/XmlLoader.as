package com.asset.xml{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.xml.*;

	public class XmlLoader extends Object {
		private var _externalXML:XML;    
		private var loader:URLLoader;
		private var mFunc:Function = null;
		public function XmlLoader(url:String,xmlReturnFunc:Function):void {
			var request:URLRequest = new URLRequest(url);
			mFunc = xmlReturnFunc;
			loader = new URLLoader();
			
			try {
				loader.load(request);
			}
			catch (error:SecurityError)
			{
				trace("A SecurityError has occurred.");
			}
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);//加载完成时触发的事件。
			}
			
			private function errorHandler(e:IOErrorEvent):void 
			{
				trace("xml加载错误"+e);
			}
	
		private function loaderCompleteHandler(event:Event):void {
			
			try {
				_externalXML = new XML(loader.data);
			} catch (e:TypeError) {
				trace("Could not parse the XML file.");
			}
			mFunc(_externalXML);
		}
		
		
		public function get externalXML():XML 
		{
			return _externalXML;
		}
		
	}
}
