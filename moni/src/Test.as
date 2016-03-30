package
{
	import com.asset.xml.NodeObject;
	import com.asset.xml.XmlToObject;
	import com.demonsters.debugger.MonsterDebugger;
	import com.ui.list.ItemList;
	
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.List;
	import fl.controls.RadioButton;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import gailv.CountGailv;
	
	import puke.PukeData;
	import puke.PukeManger;
	
	public class Test extends Sprite
	{
		private var c_select_cm:List;
		private var c_shuoming_cm:TextArea;
		private var c_getorlost_txt:TextArea;
		private var c_jushu_txt:TextInput;
		private var c_currentjushu_txt:TextInput;
		private var c_wanfa_mc:MovieClip;
		private var c_strat_btn:Button;
		private var c_shuying_txt:TextInput;
		private var peilvobj:NodeObject;
		private var c_result_txt:TextArea;
		private var c_shuchu_cb:CheckBox;
		private var c_startjiner_txt:TextInput;
		private var c_select0_rb:RadioButton;
		private var c_select1_rb:RadioButton;
		private var c_select2_rb:RadioButton;
		
		private var c_recovery_btn:Button;
		public function Test()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onStage);
			var obj:XmlToObject =  new XmlToObject("peilv.xml");
			obj.addEventListener("XMLLOADCOMPELETE",function(e:Event){
				
				peilvobj = e.target.xmlObject;
				Config.wanfa = peilvobj;
//				trace(peilvobj["龙虎斗"].child.wanfa.value);
//				trace(peilvobj["龙虎斗"].getChildNumber());
			});
		}
		protected function onStage(event:Event):void
		{
			// TODO Auto-generated method stub
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 16;
			textFormat.color = 0x000000;
			
			
			c_select_cm = Object(this).select_cm;
			c_shuoming_cm = Object(this).shuoming_cm;
			c_jushu_txt = Object(this).jushu_txt;
			c_wanfa_mc = Object(this).wanfa_mc;
			c_strat_btn= Object(this).strat_btn;
			c_result_txt = Object(this).result_txt;
			c_currentjushu_txt = Object(this).currentjushu_txt;
			c_shuying_txt = Object(this).shuying_txt;
			c_getorlost_txt = Object(this).getorlost_txt;
			c_shuchu_cb = Object(this).shuchu_cb;
			c_select0_rb =Object(this).select0_rb;
			c_select1_rb = Object(this).select1_rb;
			c_select2_rb = Object(this).select2_rb;
			c_recovery_btn = Object(this).recovery_btn;
			
			c_startjiner_txt = Object(this).startjiner_txt;
			
//			c_result_txt.setStyle("disabledTextFormat",textFormat);
			c_result_txt.setStyle("textFormat",textFormat);
			c_getorlost_txt.setStyle("textFormat",textFormat);
			c_shuchu_cb.setStyle("textFormat",textFormat);
			MonsterDebugger.initialize(this);
			MonsterDebugger.trace(this, "Hello Monster dsFlashClient cn");
			
			this.removeEventListener(Event.ADDED_TO_STAGE,onStage);
			PukeManger.instance.yanzhengAllpuke();
			addListener();
		}
		private function addListener():void
		{
			c_select_cm.addEventListener(Event.CHANGE, showData);
			c_strat_btn.addEventListener(MouseEvent.CLICK,onstart);
			c_recovery_btn.addEventListener(MouseEvent.CLICK,onRecovery);
			/*c_jushu_txt.addEventListener(Event.CHANGE, function(evt_obj:Event){
			trace(evt_obj.target.text);
			});*/
		}
		
		protected function onRecovery(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			qihao = 0;
			c_result_txt.text = "";
			c_getorlost_txt.text = "";
			
			for (var j:int = 0; j < c_wanfa_mc.numChildren; j++) 
			{
				var tempmc:* = c_wanfa_mc.getChildAt(j);
				if(tempmc is PeilvCls)
				{
					tempmc.touru_txt.text = "";
					tempmc.chanchu_txt.text = "";
					tempmc.winnum_txt.text = "";
					tempmc.gailv_txt.text = "";
					
					tempmc.winnum = 0;
					tempmc.maxChanchu = 0;
					tempmc.maxTouru = 0;
					tempmc.startMoney = 0;
				}
			}
			
			c_jushu_txt.text = "100";
			c_currentjushu_txt.text = "0";
			c_shuying_txt.text = "0";
			Object(this).zongjiner_txt.text = "123456";
			c_startjiner_txt.text = "10";
		}
		
		private var qihao:Number = 0;
		
		/**1111
		 *开始测试; 
		 * @param event
		 * 
		 */
		protected function onstart(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var num:int = int(c_jushu_txt.text);
			for (var i:int = 0; i < num; i++) 
			{
				var nums:Number = Number(c_currentjushu_txt.text);
				nums++;
				c_currentjushu_txt.text =nums.toString();
				qihao ++;
				traceResult(qihao);
			}
			
		}
		/**2222
		 *仅仅获取到当前局的信息 
		 * @param qihao
		 * 
		 */		
		private function traceResult(qihao:int):void
		{
			var temparr:Array = PukeManger.instance.productpukeBytype(Config.LONGHUDOU,qihao);
			
			for (var k:int = 0; k < temparr.length; k++) 
			{
				if(!c_shuchu_cb.selected) c_result_txt.appendText(temparr[k]);
			}
			
//			if(c_select0_rb.group.selectedData==2)
				changeRole();
				if(c_select0_rb.group.selectedData==1) changeTouruMoney();
			countgetorlost(temparr);
			
		}
		
		/**
		 *333333 
		 * 
		 */
		private function changeTouruMoney():void
		{
			for (var j:int = 0; j < c_wanfa_mc.numChildren; j++) 
			{
				
				var tempmc:* = c_wanfa_mc.getChildAt(j);
				if(tempmc is PeilvCls)
				{
					if(!tempmc.selet_cb.selected)
					{
						continue;//不需要计算的;	
					}
					//					trace((tempmc.gailv).toString());
					var an:Number;
					var tempNumer:Number = Number(tempmc.chanchu_txt.text);
					var temptouru:Number = Number(tempmc.touru_txt.text);
					
					//使得支持输入不同的起始金额;
					if(qihao==1)
					{
						if(temptouru!=0)
						{
							tempmc.startMoney = Number(tempmc.touru_txt.text);
						}else if(temptouru==0)
						{
							tempmc.startMoney = Number(c_startjiner_txt.text);
						}
					}
					
					if(Object(this).select1_1_rb.group.selectedData==0)
					{
						//保证最小值,从而保证本金;相同局数,产出过小
						if(Number(tempmc.chanchu_txt.text)<0)//如果上局输,增加投入;
						{
						var a:Number = tempmc.startMoney;
						var n:Number = qihao;
						var q:Number = 1/Number(tempmc.peilv_text.text);
						an = -Number(tempmc.chanchu_txt.text)*q;
						//						an = -(Number(tempmc.chanchu_txt.text)-tempmc.maxChanchu)*q;
						}else
						{
							an = tempmc.startMoney;
						}
					}else if(Object(this).select1_1_rb.group.selectedData==1)
					{
						//保证最大值,从而获取收入;投入最大值过大
						if((Number(tempmc.chanchu_txt.text)-tempmc.maxChanchu)<0)//如果上局输,增加投入;
						{
							var a:Number = tempmc.startMoney;
							var n:Number = qihao;
							var q:Number = 1/Number(tempmc.peilv_text.text);
							an = -(Number(tempmc.chanchu_txt.text)-tempmc.maxChanchu)*q;
						}else
						{
							an = tempmc.startMoney;
						}
					}
					
					
					
					
					tempmc.touru_txt.text = an.toString();
					//只有变动时才会有这个值;
					if(tempmc.maxTouru <an)
					{
						tempmc.maxTouru = an;
					}
					tempmc.other_txt.text = tempmc.maxTouru.toString();
				}
			}
		}
		/**3333
		 *改变赔率,得到输赢相同的赔率; 
		 * 
		 */
		private function changeRole():void
		{
			for (var j:int = 0; j < c_wanfa_mc.numChildren; j++) 
			{
				var tempmc:* = c_wanfa_mc.getChildAt(j);
				if(tempmc is PeilvCls)
				{
//					trace((tempmc.gailv).toString());
					tempmc.gailv_txt.text = tempmc.gailv.toString();
					
					if(Number(tempmc.touru_txt.text)==0)
					{
						tempmc.touru_txt.text = c_startjiner_txt.text;
					}
				}
			}
		}
		/**
		 *显示赔率; 
		 * @param event
		 * 
		 */
		protected function showData(event:Event):void
		{
			// TODO Auto-generated method stub
			c_shuoming_cm.text = "This car is priced at: $" + event.target.selectedItem.data;
			var nodeobj:NodeObject = peilvobj[event.target.selectedItem.data];
			c_wanfa_mc.removeChildren();
			var list:ItemList = new ItemList(c_wanfa_mc);
			list.lie = 4;
			list.hang = 3;
			list.lieJian = -50;
			list.hangJian = -70;
			for(var str:String in nodeobj.child)
			{
//				trace(str,nodeobj.child[str].attributes["name"]);
				var cls:MovieClip = new PeilvCls() as MovieClip;
				cls.name = nodeobj.child[str].attributes["name"];
				cls.winnum = 0;
				cls.maxChanchu = 0;
				cls.maxTouru = 0;
				cls.startMoney = 0;
				var tempobj:Object = CountGailv.instance.gailvObj;
				cls.gailv = tempobj[event.target.selectedItem.data][cls.name];
				cls.name_label.setStyle("color","#ff0000");
				cls.name_label.text = nodeobj.child[str].attributes["name"];
				cls.peilv_text.text = nodeobj.child[str].attributes["peilv"];
				/*cls.x = nodeobj.child[str].attributes["id"]*cls.width;
				if((cls.x+cls.width)>this.stage.width)
				{
					cls.y = cls.height+5;
				}*/
				list.addItem(cls);
			}
			list.refresh();
		}
		
		/**
		 * 444444
		 *仅仅计算输赢; 
		 * @param arr
		 * 
		 */
		private function countgetorlost(arr:Array):void
		{
			c_shuying_txt.text = "0";
			var tempstr:String = "期号:"+qihao.toString()+";";
			for (var j:int = 0; j < c_wanfa_mc.numChildren; j++) 
			{
				var tempmc:* = c_wanfa_mc.getChildAt(j);
				if(tempmc is PeilvCls)
				{
					if(!tempmc.selet_cb.selected)
					{
						continue;//不需要计算的;	
					}
					var temppeilv:Number = 0;
					
					if(c_select0_rb.group.selectedData==2)//n局后,不输不赢;
					{
						temppeilv = (1/tempmc.gailv)*(1-tempmc.gailv);
						tempmc.gailv_txt.text = temppeilv.toString();
						
					}else if(c_select0_rb.group.selectedData==1){
						temppeilv = Number(tempmc.peilv_text.text);
						
						/*var a:Number = Number(c_startjiner_txt.text);
						var n:Number = qihao;
						var q:Number = 1/Number(tempmc.peilv_text.text);
						var sn:Number = a*(1-Math.pow(q,n))/(1-q);
						trace("验证:",tempmc.name,sn);*/
					}else if(c_select0_rb.group.selectedData==0)//原赔率操作
					{
						temppeilv = Number(tempmc.peilv_text.text);
					}
					
					
					if(arr[tempmc.name]==1)
					{
						tempmc.winnum ++;
						tempmc.chanchu_txt.text = (Number(tempmc.chanchu_txt.text) + (temppeilv*Number(tempmc.touru_txt.text))).toString();
					}else
					{
						tempmc.chanchu_txt.text = (Number(tempmc.chanchu_txt.text) -  Number(tempmc.touru_txt.text)).toString();
					}
					tempmc.winnum_txt.text = tempmc.winnum.toString();
					if(tempmc.maxChanchu<Number(tempmc.chanchu_txt.text))
					{
						tempmc.maxChanchu = Number(tempmc.chanchu_txt.text);	
					}
					
//					trace(tempmc.name_label.text,tempmc.touru_txt.text,arr[tempmc.name]);
				}
				c_shuying_txt.text = (Number(c_shuying_txt.text)+Number(tempmc.chanchu_txt.text)).toString();
				tempstr += tempmc.name + ":("+tempmc.touru_txt.text+")"+tempmc.chanchu_txt.text+";";
			}
			tempstr += "\n";
			tempstr += "/*======分割线=======*/";
			tempstr += "\n";
			if(!c_shuchu_cb.selected) c_getorlost_txt.appendText(tempstr);
		}
	}
}