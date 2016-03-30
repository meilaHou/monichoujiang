package com.ui.button
{
	import flash.display.MovieClip;
	/**
	 * 
	 * @author Allen
	 * 
	 */	
	public class RichLittleButton extends LittleButton
	{
		private var _picsMc:MovieClip;
		public function RichLittleButton(con:MovieClip, tit:String,__picsMc:MovieClip)
		{
			super(con, tit);
			_picsMc = __picsMc;
		}

		public function set picsMc(value:MovieClip):void
		{
			_picsMc = value;
		}

		override public function init():void
		{
			setPic(int(title));
		}
		
		private function setPic(param0:int):void
		{
			// TODO Auto Generated method stub
			_picsMc.mask = content.mark_mc;
			content.pic_mc.addChild(_picsMc);
			_picsMc.x = content.mark_mc.x;
			_picsMc.y = _picsMc["numTxt"+int(title)].y;
		}
	}
}