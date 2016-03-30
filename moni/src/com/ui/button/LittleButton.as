package com.ui.button
{
	import com.GameConfig;
	import com.assist.utils.TextFieldUtils;
	import com.interfaces.ui.IUI;
	import com.ui.utils.pic.NumPicUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.osmf.media.DefaultMediaFactory;
	
	/**
	 *所有的按钮都需要手动init和手动dispose(); 
	 * @author Allen
	 * 
	 */
	public class LittleButton implements IUI
	{

		public function get state():String
		{
			return _state;
		}


		public function set hasPicsMc(value:Boolean):void
		{
			_hasPicMc = value;
		}

		public var clickFunc:Function;
		private var _state:String;//根据状态值设定;
		public var gameType:String = "";//保存彩种的常量或子彩种的名称;
		
		public var title:String;
		public var tipData:Object;
		public var content:MovieClip;
		public static const ALREADYCLICK:String = "alreadyclick";
		public static const UNCLICK:String = "unclick";
		
		//记录是否是点击;
		protected var isClick:Boolean = false;
		
		//按钮的锁定状态;
		private var _isLock:Boolean = false;
		private var _hasPicMc:Boolean;//背景图片,如果需要展示,这里赋值;
		
		//设置文本颜色;
		private var _canSetTextColor:Boolean;
		private var _firstTxtColor:int;
		private var _secondTxtColor:int;
		
		//设置是否可拥有点击状态保持;
		public var hasClickState:Boolean = true;
		
		public function set isLock(value:Boolean):void
		{
			_isLock = value;
			if(!_isLock)
			{
				addListener();
				changeState(_state);
			}else
			{
				content.gotoAndStop(4);
				removeListener();
			}
		}


		public function LittleButton(con:MovieClip,tit:String):void
		{
			content = con;
			title = tit;
//			content.addEventListener(Event.ADDED_TO_STAGE,addToStage);
//			content.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
		}
		
		
		public function init():void
		{
			content.gotoAndStop(1);
			content.mouseChildren = false;
			content.buttonMode = true;
			
			_state = LittleButton.UNCLICK;
			changeTxtColor();
			if(content["txt"]) (content.txt as TextField).text = title;
			
			if(_isLock)
			{
				content.gotoAndStop(4);
				return;
			}
			addListener();
			if(_hasPicMc)
			{
				setPic(title);
				if(content["txt"]) (content.txt as TextField).text = "";
			}
		}
		private function setPic(param0:String):void
		{
			// TODO Auto Generated method stub
			var mc:MovieClip = NumPicUtils.numToPic(param0,PanelConfig.currentPanel,content);
			//这里必然是当前彩种类型;如果不是,那么当前彩种赋值错误;
			content.pic_mc.addChild(mc);
		}
		/**
		 *还原到初始状态; 
		 * 
		 */
		public function gotoStartState():void
		{
			//默认是黑色;
			_state = LittleButton.UNCLICK;
			changeTxtColor();
			if(_isLock)
			{
				content.gotoAndStop(4);
				removeListener();
			}else
			{
				if(!content.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					addListener();
				}
//				this.changeState(_state);//调用的是子类的覆盖方法,
				switch(_state){
					case LittleButton.UNCLICK:
						content.gotoAndStop(1);
						break;
					case LittleButton.ALREADYCLICK:
						content.gotoAndStop(3);
						break;
					default:
						break;
				}
			}
		}
		private function addListener():void
		{
			content.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			content.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			content.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			content.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		}
		
		private function removeListener():void
		{
			content.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			content.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			content.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			content.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		}
		/**
		 *外部改变按钮状态的方法; 
		 * @param type
		 * 
		 */
		public function changeState(type:String):void
		{
			if(hasClickState==false)
			{
				type = UNCLICK;
			}
			_state = type;
			switch(_state){
				case LittleButton.UNCLICK:
					content.gotoAndStop(1);
					break;
				case LittleButton.ALREADYCLICK:
					content.gotoAndStop(3);
					break;
				default:
					break;
			}
			changeTxtColor();
		}
		
		/**
		 *初始化文本的颜色; 
		 * @param firstColor
		 * @param secondColor
		 * 
		 */
		public function setTxtColor(firstColor:int = 0,secondColor:int = 0):void
		{
			if(!firstColor) firstColor = 0x000000;
			if(!secondColor) secondColor = 0xffffff;
			_firstTxtColor = firstColor;
			_secondTxtColor = secondColor;
			_canSetTextColor = true;
		}
		
		/**
		 *设置文本的颜色; 
		 * 
		 */
		private function changeTxtColor():void
		{
			if(_canSetTextColor&&content["txt"])
			{
				if(state==LittleButton.ALREADYCLICK)
				{
					TextFieldUtils.setTextColor(content.txt,_secondTxtColor);
				}else
				{
					TextFieldUtils.setTextColor(content.txt,_firstTxtColor);
				}
			}
		}
		public function dispose():void
		{
			if(_hasPicMc)
			{
				removeAllchild(content.pic_mc);
			}
			_hasPicMc = false;
			removeListener();
			content = null;
			clickFunc = null;
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			if(_state == LittleButton.ALREADYCLICK) return;//如果是锁定状态,不发生over效果
			content.gotoAndStop(2);
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			if(_state == LittleButton.ALREADYCLICK) return;//如果是锁定状态,不发生out效果;
			
			content.gotoAndStop(1);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			content.gotoAndStop(3);
			isClick = true;
		}
		protected function mouseUpHandler(event:MouseEvent):void
		{
			if(_state == LittleButton.ALREADYCLICK)
			{
				_state = LittleButton.UNCLICK;
			}else
			{
				_state = LittleButton.ALREADYCLICK;
			}
			if(hasClickState==false)
			{
				_state = UNCLICK;
			}
			changeTxtColor();
			//检查是否是按钮组里的成员,如果是改变状态;
//			if(!TitileButtonGroup.instance.changeState(this))
//			{
				switch(_state){
					case LittleButton.UNCLICK:
						content.gotoAndStop(2);//over状态;
						break;
					case LittleButton.ALREADYCLICK:
						content.gotoAndStop(3);
						break;
					default:
						break;
				}
//			}
			
			
			if(isClick&&clickFunc is Function)
			{
				isClick = false;
				clickFunc(this);
			}
		}
		private function removeFromStage(event:Event):void
		{
			dispose();
		}
		private function addToStage(event:Event):void
		{
			init();
		}
		private function removeAllchild(mc:MovieClip):void
		{
				for(var i:int = mc.numChildren; i >=1 ; i--) 
				{
					mc.removeChildAt(0);
				}
				
		}
	}
}