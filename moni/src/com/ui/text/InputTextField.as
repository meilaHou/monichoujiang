package com.ui.text
{
	import com.boyojoy.logging.Log;
	import com.interfaces.ui.IUI;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;

	public class InputTextField implements IUI
	{
		private var _content:MovieClip;
		private var _txt:TextField;

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			if(value=="")
			{
				_content["bg_mc"].gotoAndStop(1);
			}else
			{
				_content["bg_mc"].gotoAndStop(2);
			}
			_text = value;
			_txt.text = _text;
		}

		public var inputFunc:Function;
		public var outputFunc:Function;
		public var onChangeFunc:Function;
		private var _text:String;
		public var isKuaijie:Boolean;
		public function InputTextField(content:MovieClip)
		{
			_content = content;
			_txt = _content.txt;
		}
		
		public function init():void
		{
			_txt.restrict = "0-9";
			text = "";
			addListener();
		}
		private function addListener():void
		{
			_txt.addEventListener(FocusEvent.FOCUS_IN,takeFocusHandler);
			_txt.addEventListener(FocusEvent.FOCUS_OUT,loseFocusHandler);
			_txt.addEventListener(KeyboardEvent.KEY_UP,onKeyUpHandler);
			_txt.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
//			_txt.addEventListener(Event.CHANGE,onChangeHandler);
		}
		private var mostNumBln:Boolean;
		protected function onKeyDownHandler(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if(_txt.text.length>=6)
			{
				mostNumBln = true;
			}
		}
		
/*		protected function onChangeHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			if(onChangeFunc is Function)
			{
				onChangeFunc(this);
			}
		}*/
		
		protected function onKeyUpHandler(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if(mostNumBln)
			{
				text = _txt.text.substr(0,6);
				mostNumBln =false;
				return;
			}
			if(isKuaijie)
			{
				if(!_txt.text)
				{
					//text = "1";
				}
				text = _txt.text;
				if(onChangeFunc is Function)
				{
					onChangeFunc(this);
				}
			}
			
		}
		
		
		
		protected function loseFocusHandler(event:FocusEvent):void
		{
			// TODO Auto-generated method stub
			text = _txt.text;
			if(outputFunc is Function)outputFunc(this);
		}
		
		protected function takeFocusHandler(event:FocusEvent):void
		{
			// TODO Auto-generated method stub
			//_txt.text = "";
			if(inputFunc is Function) inputFunc(this);
		}
		private function removeListener():void
		{
			_txt.removeEventListener(FocusEvent.FOCUS_IN,takeFocusHandler);
			_txt.removeEventListener(FocusEvent.FOCUS_OUT,loseFocusHandler);
			_txt.removeEventListener(KeyboardEvent.KEY_UP,onKeyUpHandler);
			//			_txt.removeEventListener(Event.CHANGE,onChangeHandler);
		}
		public function changeState(type:String):void
		{
			
		}
		public function dispose():void
		{
			removeListener();
			/*
			 * 
			类中的引用实例中的统一显示对象的引用
			类中的引用实例中的  对类的方法的引用
			*/
//			Log.debug("inputtextfield dispose...");
			_content = null;
			inputFunc = null;
			outputFunc = null;
			onChangeFunc = null;
			_txt = null;
		}
		
		public function gotoStartState():void
		{
			text = "";
		}
	}
}