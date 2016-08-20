package com.wg.logging 
{
	/**
	 * ...
	 * @author Bob
	 */
	public class TraceLogger extends Logger implements ILogger
	{
		
		public function TraceLogger(params:*=null) 
		{
			return;
		}
		
		override public function log(logInfo:Object) : void
		{
			trace(formatLog(logInfo));
		}		
		
	}

}