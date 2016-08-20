package com.wg.resource
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	
	public class SWFSecurityUtil
	{
		public static function requestSWFLoaderContext(isCurAppDomain:Boolean = false, isCurSecDomain:Boolean = true):LoaderContext
		{
			var loaderContext:LoaderContext = new LoaderContext();
			
			loaderContext.checkPolicyFile = isCurSecDomain;
			loaderContext.applicationDomain = isCurAppDomain ? ApplicationDomain.currentDomain : null;
			
			if(Security.sandboxType == Security.REMOTE)
			{
				loaderContext.securityDomain = isCurSecDomain ? SecurityDomain.currentDomain : null;
			}
			
			return loaderContext;
		}
		
		public static function parentSecDomainAllowNoneHttpsChildSecDomain(parentHtppsDomainURL:String):void
		{
			if(Security.sandboxType == Security.REMOTE)
			{
				if(parentHtppsDomainURL.indexOf("https") != -1)
				{
					var arr:Array = parentHtppsDomainURL.split("/");
					var domain:String = arr[2];
					
					Security.allowInsecureDomain(domain);
				}
			}
		}
	}
}