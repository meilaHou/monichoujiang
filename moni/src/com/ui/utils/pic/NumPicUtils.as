package com.ui.utils.pic
{
	import com.panels.toolbar.caipanel.SaichecaiPanel;
	
	import flash.display.MovieClip;

	/**
	 *将数字参数转换为图片mc返回; 
	 * @author Allen
	 * 
	 */
	public class NumPicUtils
	{
		public static var numPicCls:Class;
		public static var NongjialengCaiNumMc:Class;
		public static var Jiangsu3PicCls:Class;
		public static var CarNumMcCls:Class;
		public function NumPicUtils()
		{
			
		}
		
		/**
		 *根据不同的彩种类型,执行不同的转换方式; 
		 * @param num 数字
		 * @param type 类型
		 * @param parent 父容器;
		 * @return 
		 * 
		 */
		public static function numToPic(num:String,type:String,parent:MovieClip = null):MovieClip
		{
			var tempMc:MovieClip;
			var tempNum:uint = uint(num);
			switch(type)
			{
				
				case PanelConfig.XINGYUNNONGCHANG:
					tempMc = new NongjialengCaiNumMc();
					createMc();
					/*
					//所有图片在同一帧,从上到下排列
					tempMc.x = parent.mark_mc.x+(parent.mark_mc.width-tempMc["numTxt"+tempNum].width)/2;
					tempMc.y = 0-tempMc["numTxt"+tempNum].y+(parent.mark_mc.height-tempMc["numTxt"+tempNum].height)/2;*/
					//			_picsMc.y = content.mark_mc.y;
					break;
//				case PanelConfig.XIANGGANGCAI_HAOMA:
				case PanelConfig.XIANGGANGCAI:
					tempMc = new numPicCls();
					if(!parent)
					{
						tempMc.txt.text = num;
						tempMc.gotoAndStop(changeMcFrame(tempNum));
						break;
					}
					tempMc.txt.text = num;
					tempMc.gotoAndStop(changeMcFrame(tempNum));
					tempMc.mask = parent.mark_mc;
					tempMc.scaleX = 1.0;
					tempMc.scaleY = 1.0;
					tempMc.x = parent.mark_mc.x+(parent.mark_mc.width-tempMc.width)/2;
					tempMc.y = 0-tempMc.y+(parent.mark_mc.height-tempMc.height)/2;
					break;
				case PanelConfig.JIANGSUKUAI3:
					tempMc = new Jiangsu3PicCls();
					createMc();
					break;
				case PanelConfig.BEIJNGSAICHE:
					tempMc = new CarNumMcCls();
					createMc();
					break;
			}
			
			function createMc():void
			{
				if(parent) tempMc.mask = parent.mark_mc;
				tempMc.gotoAndStop(num);
			}
			
			return tempMc;
		}
		
		public static function changeMcFrame(num:uint):uint
		{
			if(num==1||num==2||num==7||num==8||num==12||num==13||num==18||num==19||num==23||num==24||num==29||num==30||num==34||num==35||num==40||num==45||num==46)
			{
				return 1;//红波
			}
			if(num==3||num==4||num==9||num==10||num==14||num==15||num==20||num==25||num==26||num==31||num==36||num==37||num==41||num==42||num==47||num==48)
			{
				return 2;//绿波
			}
			if(num==5||num==6||num==11||num==16||num==17||num==21||num==22||num==27||num==28||num==32||num==33||num==38||num==39||num==43||num==44||num==49)
			{
				return 3;//蓝波
			}
			return 0;
		}
		/**
		 *1-- maxNum
		 * @param maxNum
		 * 
		 */
		public static function randomNumNoRepeat(nums:uint,maxNum:uint):Array
		{
			var tempArr:Array = new Array();
			var num:int = 0;
			for (var i:int = 0; i < nums; i++) 
			{
				num = Math.ceil(Math.random()*maxNum);
				var num2:uint = checkNum(tempArr,num,maxNum);
				tempArr[i] = num;
			}
			
			
			return tempArr;
		}
		
		public static function checkNum(tempArr:Array,num:uint,maxNum:uint):uint
		{
//			trace("start...",tempArr,num,maxNum);
			var tempnum:uint;
			var mybln:Boolean =tempArr.every(func);
//			trace("mybln",mybln);
			if(!mybln){
//				trace("true");
				var num2:uint = Math.ceil(Math.random()*maxNum);
				tempnum = checkNum(tempArr,num2,maxNum);
			}
			return tempnum;
			
			function func(item :uint, index :int, arr:Array):Boolean
			{
//				trace("item::",item,"num::",num);
				return (item != num) ? true :false;
			}
		}
		
		public static function numToDoubleStr(num:int):String
		{
			var str:String = "";
			if(num<10)
			{
				str = "0"+num.toString();
			}else
			{
				str = num.toString();
			}
			return str;
		}
	}
}