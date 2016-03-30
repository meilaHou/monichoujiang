package com.ui.button
{
	import com.assist.utils.TextFieldUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 *投注形式 按钮 
	 * @author Allen
	 * 
	 */
	public class TouzhuLittleButton extends LittleButton
	{
		public var isTouzhu:Boolean;//是否是已经投注;
		public var groupBtnName:String = "";//保存子彩种的名称;
		public function TouzhuLittleButton(con:MovieClip, tit:String)
		{
			super(con, tit);
		}
		
		override protected function mouseUpHandler(event:MouseEvent):void
		{
			
			
			/*if(!isTouzhu)
			{
				state = LittleButton.ALREADYCLICK;
				TextFieldUtils.setTextColor(content.txt,0xffffff);
			}else
			{
				state = LittleButton.UNCLICK;
				TextFieldUtils.setTextColor(content.txt,0x000000);
			}
			isTouzhu = !isTouzhu;
			*/
			
			super.mouseUpHandler(event);
		}
		override public function gotoStartState():void
		{
//			isTouzhu = false;
			super.gotoStartState();
		}
		override public function changeState(type:String):void
		{
//			state = type;
			super.changeState(type);
			
//			isTouzhu = !isTouzhu;
		}
	}
}