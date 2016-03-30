package com.ui.button
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class LeftLittleButton extends LittleButton
	{
		public function LeftLittleButton(con:MovieClip, tit:String)
		{
			super(con, tit);
		}
		override public function init():void
		{
			super.init();
			//判断第一次登陆状态;确定第一个按钮
			if(gameType == PanelConfig.firstPanel)
			{
				changeState(LittleButton.ALREADYCLICK);
			}else
			{
				changeState(LittleButton.UNCLICK);
			}
			
		}
		override protected function mouseUpHandler(event:MouseEvent):void
		{
			ButtonGroupManger.instance.changeState(this);
			super.mouseUpHandler(event);
		}
	}
}