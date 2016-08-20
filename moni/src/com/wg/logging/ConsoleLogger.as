package com.wg.logging
{	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
//	import mx.managers.SystemManager;

	public class ConsoleLogger extends Logger implements ILogger
	{
		public static var enable:Boolean;
		
		private var _stage:Stage;
		private var _consoleMaxLine:uint = 500;
		private var _consoleHeight:uint = 300;
		private var _console:Sprite = new Sprite;
		private var _outputTxt:TextField = new TextField;
		private var _history:Array = new Array();
		private var _searchLabel:TextField = new TextField;
		private var _titleBar:Sprite = new Sprite;
		private var _barLabel:TextField = new TextField;
		private var _barGraphicsName:String = "bar";
		private var _consoleOn:Boolean = false;
		
		[Embed(source="icons/delete.gif")]
		private var _deleteIconClass:Class;

		[Embed(source="icons/search.gif")]
		private var _searchIconClass:Class;

		[Embed(source="icons/copy.jpg")]
		private var _copyIconClass:Class;

		public function ConsoleLogger(initParams:*=null) 
		{
			if (initParams != null) {
				for (var i:String in initParams) {
					this[i] = initParams[i];
				}
			}

			if (_stage == null) {
				throw new Error("stage not assigned");
			}
			
			initConsole();

			_stage.addChild(_console);	
			//先不显示
			_stage.removeChild(_console);
		}
		
		override public function log(logInfo:Object) : void
		{
			outputLog(formatLog(logInfo), logInfo['level']);
		}	
		
		private function set stage(stage:Stage) : void
		{
			_stage = stage;
		}

		private function set consoleMaxLine(consoleMaxLine:uint) : void
		{
			_consoleMaxLine = consoleMaxLine;
		}
		
		private function set consoleHeight(consoleHeight:uint) : void
		{
			_consoleHeight = consoleHeight;
		}
		
		private function initConsole() : void
		{
			initOutputTxt();
			_console.addChild(_outputTxt);
			
			initTitleBar();
			_console.addChild(_titleBar);

			_console.addEventListener(Event.ADDED, onAdded);
			_console.addEventListener(Event.REMOVED, onRemoved);
		}
		
		private function initOutputTxt() : void
		{
			_outputTxt.type = TextFieldType.INPUT;
			_outputTxt.border = true;
			_outputTxt.borderColor = 0;
			_outputTxt.background = true;
			_outputTxt.backgroundColor = 0xFFFFFF;
			_outputTxt.height = _consoleHeight;
			_outputTxt.multiline = true;
			var format:TextFormat = _outputTxt.getTextFormat();
			format.font = "Tahoma,宋体";
			_outputTxt.setTextFormat(format);
			_outputTxt.defaultTextFormat = format;
			return;
		}
		
		private function initTitleBar() : void
		{
			var barGraphics:Sprite = new Sprite();
			barGraphics.name = _barGraphicsName;

			var colors:Array = new Array(0xEFEFF1, 0xC9CACF, 0xEFEFF1);
			var alphas:Array = new Array(1, 1, 1);
			var ratios:Array = new Array(0, 50, 255);

			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(20, 20, Math.PI/2, 0, 0);
			barGraphics.graphics.lineStyle(0,0x6C6C7B);
			barGraphics.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, gradientMatrix);
			barGraphics.graphics.drawRect(0, 0, 20, 20);
			
			var format:TextFormat = _barLabel.getTextFormat();
			format.font = "Tahoma,宋体,_sans";
			_barLabel.setTextFormat(format);
			_barLabel.x = 2;
			_barLabel.mouseEnabled = false;
			_barLabel.selectable = false;
			_barLabel.autoSize = TextFieldAutoSize.LEFT;
			_barLabel.text = "Console Log";

			_searchLabel.type = TextFieldType.INPUT;
			_searchLabel.width = 80;
			_searchLabel.height = 18;
			_searchLabel.defaultTextFormat = new TextFormat("Tahoma");
			_searchLabel.addEventListener(KeyboardEvent.KEY_UP, updateHtmlText);

			var searchBg:Shape = new Shape();
			var searchIcon:DisplayObject = new _searchIconClass() as DisplayObject;
			searchBg.graphics.beginFill(0x94959D);
			searchBg.graphics.drawRect(0,0,80,17);
			searchBg.graphics.beginFill(0xD6D6D6);
			searchBg.graphics.drawRect(1,1,78,15);
			searchBg.x = _searchLabel.x = searchIcon.width + 4;
			
			var clearBut:Sprite = new Sprite();
			var clearButUp:DisplayObject = new _deleteIconClass() as DisplayObject;
			clearBut.addChild(clearButUp);
			clearBut.addEventListener(MouseEvent.CLICK, onClear);			
			clearBut.x = searchBg.x + searchBg.width + 4;

			var tools:Sprite = new Sprite;
			tools.name = 'tools';			
			tools.addChild(searchIcon);
			tools.addChild(searchBg);
			tools.addChild(_searchLabel);
			tools.addChild(clearBut);
			tools.y = 2;
			
			_titleBar.addChild(barGraphics);
			_titleBar.addChild(_barLabel);
			_titleBar.addChild(tools);
			
			var copyIcon:Sprite = new Sprite();
			var copyIconChild:DisplayObject = new _copyIconClass() as DisplayObject;
			copyIconChild.width = copyIconChild.height = 18;
			copyIcon.addChild(copyIconChild);
			copyIcon.x = searchIcon.x - copyIcon.width - 5;
			tools.addChild(copyIcon);
			copyIcon.addEventListener(MouseEvent.CLICK, onCopyIconClick);
			return;
		}
		
		private function onCopyIconClick(event:MouseEvent):void
		{
			System.setClipboard(_outputTxt.text);
		}
		
		private function outputLog(log:String, level:String) : void
		{
			_history.push({s:log, c:"<font color='" + getColorByLevel(level) + "'>" + log + "</font>"});
			if (_history.length > _consoleMaxLine) {
				_history.shift();
			}
			if (_consoleOn) {
				updateHtmlText();
			}			
		}
		
		private function updateHtmlText(event:Event=null) : void
		{
			var targetStrings:Array = [];
			var len:uint = _history.length;
			var i:uint;

			if (_searchLabel.text.length > 0) {
				var serachStr:String = _searchLabel.text;
				for (i = 0; i < len; ++i) {
					if (_history[i].s.indexOf(serachStr) != -1) {
						targetStrings.push(_history[i].c);
					}
				}
			}
			else {
				for (i = 0; i < len; ++i) {
					targetStrings.push(_history[i].c);
				}
			}
			
			_outputTxt.text = "";
			_outputTxt.htmlText = targetStrings.join('<br>');
			_outputTxt.scrollV = _outputTxt.maxScrollV;
		}

		private function fitToStage(event:Event=null) : void 
		{
			_outputTxt.width = _stage.stageWidth;
			_outputTxt.y = _stage.stageHeight - _outputTxt.height;
			_titleBar.y = (_outputTxt.visible) ? _outputTxt.y - _titleBar.height : _stage.stageHeight - _titleBar.height;
			_titleBar.getChildByName(_barGraphicsName).width = _stage.stageWidth;		
			
			var tools:DisplayObject = _titleBar.getChildByName("tools");
			tools.x = _console.stage.stageWidth - tools.width - 4;			
		}
		
		private function onAdded(event:Event) : void
		{
			_console.stage.addEventListener(Event.RESIZE, fitToStage);
			_console.stage.addEventListener(KeyboardEvent.KEY_DOWN, onShortcutKey);
			_outputTxt.addEventListener(KeyboardEvent.KEY_UP, onOutputTxtKeyUp);
			_consoleOn = true;
			fitToStage();
			updateHtmlText();
		}
		
		private function onRemoved(evt:Event) : void
		{
			_console.stage.removeEventListener(Event.RESIZE, fitToStage);
			_consoleOn = false;
		}
		
		private function onOutputTxtKeyUp(event:KeyboardEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		private function onShortcutKey(event:KeyboardEvent) : void
		{
			if(!enable)
			{
				return;
			}
				
			
			if (event.keyCode != 113) {
				return;
			}
			
			if (_consoleOn) {
				_stage.removeChild(_console);
			}
			else {
				_stage.addChild(_console);
			}

			return;
		}
		
		private function onClear(event:MouseEvent = null) : void
		{
			_outputTxt.text = "";
			_searchLabel.text = "";
			_history = new Array();
		}
		
		private static function getColorByLevel(level:String) : String
		{
			switch (level) {
				case 'trace': return "#00CC33";
				case 'debug': return "#666666";
				case 'info': return "#0066FF";
				case 'warn': return "#FFCC00";
				case 'error': return "#FF0000";
				case 'fatal': return "#990000";
				case 'profiler': return "#9900CC";
				default: return "#000000";
			}
		}
	}
}