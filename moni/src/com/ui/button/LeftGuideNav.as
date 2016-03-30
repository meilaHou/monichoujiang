package com.ui.button
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class LeftGuideNav extends Sprite
	{
		private var _content:MovieClip;
		public var titleData:Object;
		public static var supbtnCls:Class;
		public static var childbtnCls:Class;
		public static var TipMCCls:Class;
		public function LeftGuideNav(content:MovieClip)
		{
			_content  = content;
		}
		
		public function init():void
		{
////			supbtnCls = getDefinitionByName(_content.supBtn.prototype.constructor) as Class;
//			trace(getQualifiedClassName(_content.supBtn));
//			supbtnCls = getDefinitionByName(getQualifiedClassName(_content.supBtn)) as Class;
////			childbtnCls = getDefinitionByName(getQualifiedClassName(_content.childBtn)) as Class;
			removeAllchild();
			initData();
			GlobalTimer.instance.pushFunc(timeFunc);
		}
		
		private var LeftLittleButtonArr:Array;
		private function initData():void
		{
			LeftLittleButtonArr = new Array();
			for(var obj:Object in titleData)
			{
				
				if(titleData[obj].type=="menu")
				{
					var tempbtn:LeftLittleButton = new LeftLittleButton(new supbtnCls().btn,titleData[obj].attributes["name"]);
					tempbtn.gameType = titleData[obj].attributes["id"];
					
					tempbtn.clickFunc = supbtnClick;
					tempbtn.init();
					tempbtn.isLock = true;
					//按钮组需要首先确定父容器;
					LeftLittleButtonArr[int(titleData[obj].attributes["index"])] = tempbtn;
					
					
					if(titleData[obj].child)
					{
						createChildBtn(titleData[obj].child,tempbtn);
					}
				}
			}
			for (var i:int = 0; i < LeftLittleButtonArr.length; i++) 
			{
				LeftLittleButtonArr[i].content.parent.x = 0;
				LeftLittleButtonArr[i].content.parent.y = tempbtn.content.parent.height*i;
				_content.addChild(LeftLittleButtonArr[i].content.parent);
				ButtonGroupManger.instance.addBtn(LeftLittleButtonArr[i]);//添加的按钮组必须有父类;
			}
			
			
			/*for (var i:int = 0; i < titleDa; i++) 
			{
				
			}*/
			
		}
		private var timeTick:uint = 1000;
		private function timeFunc():void
		{
			
			for (var i:int = 0; i < LeftLittleButtonArr.length; i++) 
			{
				LeftLittleButtonArr[i].content.parent.timeMc.timeTxt.text = GlobalTimer.instance.getHourMinuteSecondsBySeconds(timeTick);
			}
			timeTick--;
		}
		private function supbtnClick(btn:LittleButton):void
		{
			// TODO Auto Generated method stub
			var childHeight:int = 0;
			for each (var j:Sprite in menuDic) 
			{
				j.visible = false;
				ButtonGroupManger.instance.resetState(j);
			}
			
			for (var i:int = 0; i < LeftLittleButtonArr.length; i++)
			{
				var tempbtn:LittleButton = LeftLittleButtonArr[i];
				tempbtn.content.x = 0;
				tempbtn.content.y = tempbtn.content.height*i+childHeight;
				
				if(tempbtn==btn)
				{
					if(menuDic[btn])
					{
						menuDic[btn].visible = true;
						menuDic[btn].x = 0;
						menuDic[btn].y = tempbtn.content.height*(i+1);
						childHeight = menuDic[btn].height;
					}
				}
			}
			
		}
		private var menuDic:Dictionary = new Dictionary();
		
		private function createChildBtn(childobj:Object,parentBtn:LittleButton):void
		{
			var supContainer:Sprite = new Sprite();
			supContainer.visible = false;
			menuDic[parentBtn] = supContainer;
			var num:int = 0;
//			LeftchildLittleButtonArr = new Array();
			for(var obj:Object in childobj)
			{
				
				if(childobj[obj].type=="submenu")
				{
					var tempbtn:LeftLittleButton = new LeftLittleButton(new childbtnCls(),childobj[obj].attributes["name"]);
					tempbtn.gameType = childobj[obj].attributes["id"];
					tempbtn.content.x = 0;
					tempbtn.content.y = tempbtn.content.height*num;
					num++;
					tempbtn.init();
					//					tempbtn.isLock = true;
					
					supContainer.addChild(tempbtn.content);
					
					//按钮组需要首先确定父容器;
					ButtonGroupManger.instance.addBtn(tempbtn);
					
//					if(typeof(titleData[obj].child)=="object")//暂时支持两级;
//					{
//						trace(titleData[obj].child);
//					}
				}
			}
			supContainer.x = 300;
			supContainer.y = 0;
			_content.addChild(supContainer);
		}
		private function removeAllchild():void
		{
			for (var i:int = _content.numChildren; i >=1 ; i--) 
			{
				_content.removeChildAt(0);
			}
			
		}
		public function dispose():void
		{
			GlobalTimer.instance.delFunc(timeFunc);
		}
	}
}