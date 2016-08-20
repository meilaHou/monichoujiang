package
{
	import com.wg.logging.Log;
	import com.wg.resource.ResourceLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	[SWF(width=1500,height=1024,frameRate='30')]
	public class moni extends Sprite
	{
		private var resloader:ResourceLoader;
		public function moni()
		{
			//test.fla 绑定Test.as
			
		/**
		 *几何加注 ,将不确定的概率因素转化为百分百确定的有无事件, 概率的变化转换成最大押注金额的变化;赔率的变化影响每局加注的金额数量;
		 * 每局押注不变的情况下,五五开的公平胜负概率,由赔率和原始概率决定;
		 * 
		 * 数量越多越平均??
		 * 
		 * 胜负判定
		 * 发牌判定  牌数 -跟牌规则
		 * 牌型
		 * 金额限定
		 * 
		 */
			initDebugModule();
			loadswf();
		}
		
		private function initDebugModule():void
		{
			// TODO Auto Generated method stub
			//config 模拟:模拟html传过来的数据;有真数据后替换掉;
			var Logs:Object = {
				loggers: [
					{
						name: "TraceLogger",//支持 编译工具 输出log到控制台
						//levels: "trace-debug-warn"   //trace-debug-warn   支持输出某种log;
						levels: "*"
					},
					{
						name: "ConsoleLogger",//支持  运行项目内 console 文本框输出日志;
						levels: "*"
					}
				]
			};
			Log.instance.init(formatLogConfig(Logs));
			//new ClientdebugLogic(this);//显示在舞台上的 调试语句;
			Log.debug("这里是测试说明");
			Log.trace("这里是测试说明");
			Log.warn("这里是测试说明");
			Log.error("这里是测试说明");
			Log.fatal("这里是测试说明");
			Log.profiler("这里是测试说明");
		}
		
		private function loadswf():void
		{
			// TODO Auto Generated method stub
			resloader = new ResourceLoader();
			resloader.load([resloader.getLoadData("lib/test.swf","testcls")],function(path:String, bytesLoaded:uint=1, bytesTotal:uint=1):void{}, onLoadComplete);
			
		}
		private function formatLogConfig(config:*) : *
		{
			if (config != null) {
				for each (var logger:Object in config['loggers']) {
					if (logger['name'] == "ConsoleLogger") {
						logger['params'] = { stage: this.stage };
					}
				}
			}
			return config;
		}
		private function onLoadComplete():void
		{
			var maincls:Class = resloader.getClass("test","testcls");
			var tempmc:MovieClip = new maincls();
			
			var peilvcls:Class = resloader.getClass("PeilvCls","testcls");
			//this.addChild(tempmc);
			var testmc:Test = new Test(tempmc,peilvcls);
			this.addChild(testmc);
		}
	}
}