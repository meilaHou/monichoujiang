package com.ui.list
{
	import flash.display.Sprite;
	import flash.events.UncaughtErrorEvent;
	
	public class ItemList
	{
		//设置行数
		private var _hang:int = 1;//设置行数
		private var _lie:int = 1;//设置列数
		
		private var _dengju:Boolean;//设置是否等间距显示
		private var _hangJian:int = 10;//设置行间距
		private var _lieJian:int = 10;//设置列间距
		
		
		private var _kuangDuiqi:String = "top"//设置整体对齐方式,left,right,top,bottom 自上到下排列;
		private var _mcDuiqi:String = "left";//设置mc的对齐方式left,right,top,bottom,center
		
		private var _mcArray:Array = new Array();
		private var _hasAdded:Boolean;
		private var _parent:*;
		public function ItemList(parent:*)
		{
			_parent = parent;
			super();
		}
		//添加元素
		
		public function get lieJian():int
		{
			return _lieJian;
		}

		public function set lieJian(value:int):void
		{
			_lieJian = value;
		}

		public function get hangJian():int
		{
			return _hangJian;
		}

		public function set hangJian(value:int):void
		{
			_hangJian = value;
		}

		public function get lie():int
		{
			return _lie;
		}
		
		public function set lie(value:int):void
		{
			_lie = value;
		}
		
		public function get hang():int
		{
			return _hang;
		}
		
		public function set hang(value:int):void
		{
			_hang = value;
		}
		
		public function addItem(child:*):void
		{
			_mcArray.push(child);
			_parent.addChild(child);
		}
		
		public function hasItem(child:*):Boolean
		{
			var tempBln:Boolean;
			for (var i:int = 0; i < _mcArray.length; i++) 
			{
				if(child==_mcArray[i])
				{
					tempBln = true;
					break;
				}
			}
			return tempBln;
			
		}
		public function removeAllItem():void
		{
			/*for (var i:int = 0; i < _mcArray.length; i++) 
			{
				delItem(_mcArray[i]);
			}*/
			_mcArray = new Array();
			
		}
		//删除元素
		public function delItem(child:*):void
		{
			for (var i:int = 0; i < _mcArray.length; i++) 
			{
				if(child == _mcArray[i])
				{
					_mcArray.splice(i,1);
					_parent.removeChild(child);
					break;
				}
			}
			
		}
		//排列元素
		public function refresh():void
		{
			if(_mcArray.length==0)
			{
				return;
			}
			for (var i:int = 0; i < _hang; i++) 
			{
				for (var j:int = 0; j < _lie; j++) 
				{
					if(j==0&&i==0)
					{
						_mcArray[0].x = 0;
						_mcArray[0].y = 0;
						continue;
					}
					var index:int = i*_lie+j;
					if(index>=_mcArray.length)
					{
						break;
					}
					if((index%_lie)==0)
					{
						_mcArray[index].x = 0;
					}else
					{
						_mcArray[index].x = _mcArray[index-1].x+_mcArray[index-1].width+_lieJian;
					}
					
					if((index-_lie)<0)
					{
						_mcArray[index].y = 0;
					}else
					{
						switch(_kuangDuiqi)
						{
							case "bottom":
							{
								_mcArray[index].y = _mcArray[index-_lie].y-_mcArray[index-_lie].height-_hangJian;
								break;
							}
							case "top":
								_mcArray[index].y = _mcArray[index-_lie].y+_mcArray[index-_lie].height+_hangJian;
								break;
							default:
							{
								break;
							}
						}
						
					}
				}
				
			}
			
		}
	}
}