package com.wg.logging 
{
	import com.wg.utils.stringUtils.StringUtil;
	
	public class Logger implements ILogger 
	{
		public static function formatUnsignedInt(i:uint, width:uint) : String
		{
			var s:String = i.toString();
			var needWidth:int = width - s.length;
			var array:Array = [];
			while (needWidth > 0) { 
				array.push(0);
				--needWidth;
			}
			return array.join("") + s;
		}
		
		public static function formatLog(logInfo:Object) : String
		{
			var data:String = '';
			for each( var arg:* in logInfo.data ) {				
				var val:String;
				if (arg === null) {
					val = "<null>";
				}
				else if (arg === undefined) {
					val = "<undefined>";
				}
				else {
					val = arg.toString();
				}
				data = ( data == null ? "" : data.concat(" ") );
				data = data.concat(val);	
			}
			/*
			var time:String = StringUtil.sprintf("%.2d:%.2d:%.2d.%.3d", 
			logInfo.date.getHours(), 
			logInfo.date.getMinutes(), 
			logInfo.date.getSeconds(), 
			logInfo.date.getMilliseconds()); 
			*/
			var time:String = logInfo.date.getHours()+
				":"+logInfo.date.getMinutes()+
				":"+logInfo.date.getSeconds()+
				":"+logInfo.date.getMilliseconds();
			
			var logLevel:String = Log.LEVEL[logInfo.level];
			if (logLevel == null) {
				logLevel = logInfo.level;
			}
			
			return "[" + time  + "][" + logLevel + "][" + logInfo.func + ":" + logInfo.line + "] " + data;
		}
		
		public function Logger() 
		{
			return;
		}
		
		public function log(logInfo:Object) : void
		{
			return;
		}
	}
}
import com.wg.logging;

