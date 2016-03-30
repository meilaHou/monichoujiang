package com.ui.button
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class LittleGroupButton extends LittleButton
	{
		public function LittleGroupButton(con:MovieClip, tit:String)
		{
			super(con, tit);
		}
		
		override public function init():void
		{
			super.init();
			//判断第一次登陆状态;
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
			if(isClick&&clickFunc is Function&&state == LittleButton.UNCLICK)
			{
				isClick = false;
				clickFunc(this);
			}
			ButtonGroupManger.instance.changeState(this);
			
			//统一在管理类中调用super();
//			super.mouseUpHandler(event);
			
		}
		override public function dispose():void
		{
			ButtonGroupManger.instance.removeBtn(this);
			super.dispose();
		}
	}
}