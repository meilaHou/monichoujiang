package com.ui.text
{
	import com.interfaces.ui.IUI;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextFieldAutoSize;
	
	public class LunboTextField implements IUI
	{
		private var _content:MovieClip;
		System.useCodePage = true; 
		private var txt_url:String = "my_txt.txt"; 
		private var txt_req:URLRequest = new URLRequest(txt_url); 
		private var txt_load:URLLoader = new URLLoader(txt_req); 
		
		private var startX:int = 0;
		public function LunboTextField(content:MovieClip)
		{
			_content = content;
			init();
		}
		
		public function init():void
		{
			startX = _content.mask_mc.x + _content.mask_mc.width;
			txt_load.addEventListener(Event.COMPLETE,LoadCompleteHandler);
			_content.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			
		}
		
		public function changeState(type:String):void
		{
			
		}
		
		public function dispose():void
		{
			
		}
		
		private function LoadCompleteHandler(event:Event):void { 
			_content.my_txt.htmlText = txt_load.data; 
			_content.my_txt.autoSize = TextFieldAutoSize.LEFT; 
			_content.my_txt.selectable = true; 
			_content.my_txt.condenseWhite = true; 
			_content.my_txt.mask = _content.mask_mc; //遮罩;
			//var my_filter:GlowFilter = new GlowFilter(0xFF0000,1,2,2,3,1, false,false); 
			//_content.my_txt.filters = [my_filter]; 
			_content.my_txt1.background = false; //文字背景颜色;
			_content.my_txt1.backgroundColor = 0xf4f8f9; 
			_content.my_txt1.border = false; 
			_content.my_txt1.borderColor = 0xff0000; 
			_content.my_txt.addEventListener(Event.ENTER_FRAME,enterframeHandler); //文字内容
			_content.my_txt.x = startX; 
		}
		
		private function enterframeHandler(event:Event):void { 
			_content.my_txt.x -= 2;
			_content.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			if (_content.my_txt.x < -_content.my_txt.width) 
			{
				_content.my_txt.x = startX; 
			} 
		}
		
		private function overHandler(event:MouseEvent):void 
		{
				_content.my_txt.removeEventListener(Event.ENTER_FRAME,enterframeHandler); 
		}
			
		private function mouseOutHandler(event:MouseEvent):void 
		{
				_content.my_txt.addEventListener(Event.ENTER_FRAME,enterframeHandler);
		}
	} 
}