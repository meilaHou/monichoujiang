package puke
{

	public class PukeManger
	{
		private static var _instance:PukeManger;
		public function PukeManger()
		{
			if(_instance)
			{
				throw new Error("单例...");
			}
			productAllData();//第一次初始化的时候执行;
		}
		
		public static function get instance():PukeManger
		{
			if(!_instance)
			{
				_instance = new PukeManger();
			}
			return _instance;
		}

		public static function set instance(value:PukeManger):void
		{
			_instance = value;
		}

		private function productAllData():void
		{
			if(!Config.pukeArr)
			{
				Config.pukeArr = new Array();
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
		
		
		public function yanzhengAllpuke():void
		{
			for (var i:int = 0; i < Config.pukeArr.length; i++) 
			{
				trace(Config.pukeArr[i].num,Config.pukeArr[i].huase);
			}
			
		}
		
		/**
		 *根据num返回随机生成的扑克牌 
		 * @param num
		 * @return 
		 * 
		 */
		public function getrandomPuke(num:int):Vector.<PukeData>
		{
			var tempArr:Vector.<PukeData> = new Vector.<PukeData>();
			for (var i:int = 0; i < num; i++) 
			{
				var randomnum:int = Math.floor(Math.random()*52);
				tempArr.push(Config.pukeArr[randomnum]);
			}
			return tempArr;
		}
		
		/**
		 * 根据游戏玩法,返回所有的生成的扑克牌; 
		 * @param type  游戏类型;
		 * @param state 游戏进行到哪一阶段;//等于0是自动生成所有阶段;
		 * 
		 */
		public function productpukeBytype(type:String,qihao:int,state:int = 0):Array
		{
			var orderArr:Array = [];
			var resultObj:Object = {};
			var resultStrArr:Array = [];
			var playerArr:Array = Config.playerObj[type];
			for (var i:int = 0; i < playerArr.length; i++) 
			{
				resultObj[playerArr[i]] = new Array();
			}
			switch(type)
			{
				case Config.LONGHUDOU:
				{
					//根据发牌步骤进行计算和存储,阶段的划分是按照玩家参与操作的次数
					if(state==0)
					{
						resultObj["龙"].push(getrandomPuke(1));
						orderArr.push((["龙",state,0]));
						resultObj["虎"].push(getrandomPuke(1));
						orderArr.push((["虎",state,0]));
						resultObj["state"] = orderArr;
					}
					resultStrArr = countLonghuResult(resultObj,qihao);
					break;
				}
					
				default:
				{
					break;
				}
			}
			return resultStrArr;
		}
		
		/**
		 *根据龙虎的出牌计算结果; 
		 * @param pukeObj
		 * 
		 */
		private function countLonghuResult(pukeObj:Object,qihao:int):Array
		{
			// TODO Auto Generated method stub
			var tempArr:Array = [];
			var longhu:String;
			var playerArr:Array = Config.playerObj[Config.LONGHUDOU];
			var playernum:int = playerArr.length;
			var resulttr:String = "";
			
			//每个阶段比较拥有的所有的牌的点数的和的大小;
			var stateArr:Array = pukeObj["state"];
			var playnumaddArr:Array = []; 
			//这里计算每个玩家的点数总和,所以不单独处理每个阶段的,对所有的扑克牌进行遍历;
			for (var k:int = 0; k < stateArr.length; k++) 
			{
				if(!playnumaddArr[stateArr[k][0]]) playnumaddArr[stateArr[k][0]] = 0;
				var names = stateArr[k][0];
				var temppukeArr:Vector.<PukeData> = (pukeObj[names] as Array)[stateArr[k][2]];//获取某一玩家某一阶段的扑克牌
				//将某一阶段的扑克数值相加;
				for (var i2:int = 0; i2 < temppukeArr.length; i2++) 
				{
					playnumaddArr[stateArr[k][0]] += (temppukeArr[i2] as PukeData).num;
					
					//龙虎只有一个值,所以花色可以在这里计算
					if((temppukeArr[i2] as PukeData).huase%2==0)
					{
						tempArr[stateArr[k][0]+"红"] = 1;
						tempArr[stateArr[k][0]+"黑"] = 0;
					}else
					{
						tempArr[stateArr[k][0]+"红"] = 0;
						tempArr[stateArr[k][0]+"黑"] = 1;
					}
					
				}
				
				//stateArr[k][2];//也有可能发的不是一张牌的;
				/*for (var i2:int = 0; i2 < playernum; i2++) 
				{
					var tempstation:int = stateArr[playerArr[playernum]][1];
				}*/
				
			}
			//计算龙虎大小
			if(playnumaddArr["龙"]>playnumaddArr["虎"])
			{
				tempArr["龙"] = 1;
				tempArr["虎"] = 0;
				tempArr["和"] = 0;
			}else if(playnumaddArr["龙"]==playnumaddArr["虎"])
			{
				tempArr["龙"] = 0;
				tempArr["虎"] = 0;
				tempArr["和"] = 1;
			}else
			{
				tempArr["龙"] = 0;
				tempArr["虎"] = 1;
				tempArr["和"] = 0;
			}
			
			if(playnumaddArr["龙"]%2!=0)
			{
				tempArr["龙单"] = 1;
				tempArr["龙双"] = 0;
			}else
			{
				tempArr["龙单"] = 0;
				tempArr["龙双"] = 1;
			}
			if(playnumaddArr["虎"]%2!=0)
			{
				tempArr["虎单"] = 1;
				tempArr["虎双"] = 0;
			}else
			{
				tempArr["虎单"] = 0;
				tempArr["虎双"] = 1;
			}
			
			var resultStr:String = "";
			for(var name:String in tempArr)
			{
				resultStr +=name + ":"+tempArr[name];
			}
			resultStr += "\n";
			
			
			for (var j:int = 0; j < playerArr.length; j++) 
			{
				//对每个玩家的牌进行处理;
				var temppukearr:Array =  pukeObj[playerArr[j]];
				for (var i:int = 0; i < temppukearr.length; i++) 
				{
					if(!temppukearr[i][0])
					{
						trace("数字错误...");
					}
					tempArr.push("期号:"+qihao+" 玩家:"+playerArr[j]+" "+temppukearr[i][0].huase+"/"+temppukearr[i][0].num+"\n");
//					c_result_txt.appendText();
				}
			}
			tempArr.push(resultStr);
			
			return tempArr;
			
		}
		
	}
}