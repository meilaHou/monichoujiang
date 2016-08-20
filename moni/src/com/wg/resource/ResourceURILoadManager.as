package com.wg.resource
{
	import com.wg.loading.UrlData;
	import com.wg.loading.UrlScrData;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @用途
	 */
	public class ResourceURILoadManager
	{
		private var _resourceConfigLoader:URLLoader;
		
		private var resourceList:Array;
		public function ResourceURILoadManager()
		{
			init();
		}
		
		private function init():void
		{
			resourceList = [];
			_resourceConfigLoader = new URLLoader;
			_resourceConfigLoader.addEventListener(ProgressEvent.PROGRESS, configLoaderProgressHandler);
			_resourceConfigLoader.addEventListener(Event.COMPLETE, configLoaderCompleteHandler);
			_resourceConfigLoader.addEventListener(IOErrorEvent.IO_ERROR, configLoaderErrorHandler);
			_resourceConfigLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, configLoaderErrorHandler);
		}
		
		private var currLoadData:UrlScrData;
		public function load(resourcePath:*):void
		{
			if(resourcePath is Array)
			{
				resourceList = resourceList.concat(resourcePath);
			}
			else if(resourcePath is UrlData)
			{
				resourceList.push(resourcePath);
			}else{
				return;
			}
			
			if(!isOnLoading)
			{
				next();
			}
		}
		
		private var isOnLoading:Boolean = false;
		public function next():void
		{
			if(resourceList.length>0)
			{
				currLoadData = resourceList.shift();
				isOnLoading = true;
				_resourceConfigLoader.load(new URLRequest(currLoadData.key));
			}
			else
			{
				currLoadData = null;
			}
		}
		
		private function configLoaderProgressHandler(event:ProgressEvent):void
		{
			if(currLoadData&&currLoadData.progressFun is Function)
			{
				currLoadData.progressFun(event.bytesLoaded,event.bytesTotal);
			}
		}
		
		private function configLoaderCompleteHandler(event:Event):void
		{
			currLoadData.data = _resourceConfigLoader.data;
			
			if(currLoadData.recallFun is Function)
			{
				currLoadData.recallFun(currLoadData);
			}
			
			isOnLoading = false;
			
			next();
		}
		
		private function configLoaderErrorHandler(event:Event):void
		{
			trace(event);
			
			isOnLoading = false;
			
			next();
		}
		
		public function dispose():void
		{
			resourceList.length = 0
			_resourceConfigLoader.removeEventListener(ProgressEvent.PROGRESS, configLoaderProgressHandler);
			_resourceConfigLoader.removeEventListener(Event.COMPLETE, configLoaderCompleteHandler);
			_resourceConfigLoader.removeEventListener(IOErrorEvent.IO_ERROR, configLoaderErrorHandler);
			_resourceConfigLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, configLoaderErrorHandler);
		}
	}
}