package gailv
{
	import puke.PukeData;

	public class CountGailv
	{
		private static var _instance:CountGailv;
		/*一副牌中的数据*/
		public static const TOTALNUM:int = 52;
		public static const HEIGAILV:Number = 0.5;
		public static const HONGGAILV:Number = 0.5;
		
		
		private var randomnum:int = 13;
		private var huaseArr:Array = [0,1,2,3];
		private var pukeArr:Array;
		private var _gailvObj:Object;
		private var _heiseGailv:Number;
		private var _hongseGailv:Number;
		private var putoff:Boolean;
		private var _danGailv:Number;
		private var _shuangGailv:Number;
		private var _daGailv:Number;
		private var _xiaoGailv:Number;
		private var _hegailv:Number;
		public function CountGailv()
		{
			if(_instance)
			{
				throw new Error("单例...");
			}
			
		}

		public function get hegailv():Number
		{
			if(!_hegailv)
			{
				_hegailv = (4/52)*(4/52)*13;
			}
			return _hegailv;
		}

		public function get xiaoGailv():Number
		{
			if(!_xiaoGailv)
			{
				_xiaoGailv = ((1-hegailv)/2);
			}
			return _xiaoGailv;
		}

		public function get daGailv():Number
		{
			//大小的意思是,押注某牌大的概率,大小和三个出现概率比是  6/6/1;分别出现的概率是6/13 6/13 1/13;
			if(!_daGailv)
			{
				_daGailv = ((1-hegailv)/2);
			}
			return _daGailv;
		}

		public function get shuangGailv():Number
		{
			if(!_shuangGailv)
			{
				 var dannum:Number = 0;
				for (var i:int = 0; i <Config.pukeArr.length; i++) 
				{
					if(Config.pukeArr[i].num%2==0)
					{
						dannum++;
					}
				}
				
				_shuangGailv = dannum/TOTALNUM;
			}
			return _shuangGailv;
		}

		public function get danGailv():Number
		{
			if(!_danGailv)
			{
				 var dannum:Number = 0;
				for (var i:int = 0; i <Config.pukeArr.length; i++) 
				{
					if(Config.pukeArr[i].num%2!=0)
					{
						dannum++;
					}
				}
				
				_danGailv = dannum/TOTALNUM;
			}
			return _danGailv;
		}

		
		public function get hongseGailv():Number
		{
			if(!_hongseGailv)
			{
				if(!putoff)
				{
					 var dannum:Number = 0;
					for (var i:int = 0; i <Config.pukeArr.length; i++) 
					{
						if(Config.pukeArr[i].huase%2==0)
						{
							dannum++;
						}
					}
					_hongseGailv = dannum/TOTALNUM;
				}else
				{
					//克隆一副扑克牌,然后剔除已经被抽出来的牌,再进行计算;
				}
				
			}
			return _hongseGailv;
		}

		/**
		 *一副牌中抽出黑色牌的概率; 
		 * 
		 */
		public function get heiseGailv():Number
		{
			if(!_heiseGailv)
			{
				if(!putoff)
				{
					 var dannum:Number = 0;
					for (var i:int = 0; i <Config.pukeArr.length; i++) 
					{
						if(Config.pukeArr[i].huase%2!=0)
						{
							dannum++;
						}
					}
					_heiseGailv = dannum/TOTALNUM;
				}else
				{
					//克隆一副扑克牌,然后剔除已经被抽出来的牌,再进行计算;
				}
				
			}
			return _heiseGailv;
		}

		public function get gailvObj():Object
		{
			if(!_gailvObj) setWanfa();
			return _gailvObj;
		}

		public function set gailvObj(value:Object):void
		{
			_gailvObj = value;
		}

		public static function get instance():CountGailv
		{
			if(!_instance)
			{
				_instance = new CountGailv();
			}
			return _instance;
		}
		
		public static function set instance(value:CountGailv):void
		{
			_instance = value;
		}
		
		
		private function productAllData():void
		{
			if(!pukeArr)
			{
				pukeArr = new Array();
				for (var i:int = 1; i <= 13; i++) 
				{
					
					for (var j:int = 0; j < 4; j++) 
					{
						var temppuke:PukeData = new PukeData();
						temppuke.num = (i);
						temppuke.huase = j;
						Config.pukeArr.push(temppuke);
					}
					
				}
			}
		}
		
		/*  不计算抽出的牌   */
		
		private function countLongHuGailv():void
		{
			
			_gailvObj[Config.LONGHUDOU]["龙单"] = danGailv;
			_gailvObj[Config.LONGHUDOU]["龙双"] = shuangGailv;
			_gailvObj[Config.LONGHUDOU]["龙红"] = hongseGailv;
			_gailvObj[Config.LONGHUDOU]["龙黑"] = heiseGailv;
			
			
			_gailvObj[Config.LONGHUDOU]["虎单"] = danGailv;
			_gailvObj[Config.LONGHUDOU]["虎双"] = shuangGailv;
			_gailvObj[Config.LONGHUDOU]["虎红"] = hongseGailv;
			_gailvObj[Config.LONGHUDOU]["虎黑"] = heiseGailv;
			
			_gailvObj[Config.LONGHUDOU]["龙"] = daGailv;
			_gailvObj[Config.LONGHUDOU]["虎"] = daGailv;
			_gailvObj[Config.LONGHUDOU]["和"] = hegailv;
		}
		
		private function setWanfa():void
		{
			_gailvObj = new Object();
			for(var name:String in Config.wanfa)
			{
				var tempobj:Object = Config.wanfa[name];
				_gailvObj[name] = new Object();
				for(var str:String in tempobj.child)
				{
					_gailvObj[name][tempobj.child[str].attributes["name"]] = 1.1;
				}
			}
				
			//设置龙虎概率;
			countLongHuGailv();
		}
		/*
		 * 
		不放回抽样和放回抽样
		*/
	}
}