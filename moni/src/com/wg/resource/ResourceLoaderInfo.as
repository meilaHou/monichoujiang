package com.wg.resource
{
	import com.wg.logging.Log;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	public class ResourceLoaderInfo
	{
		private var _loader:Loader;
		private var _resourceManager:ResourceManager;
		private var _resourceLoaderData:ResourceLoaderData;
		
		private var _progressCallback:Function;
		private var _completeCallback:Function;
		
		public function ResourceLoaderInfo(resourceManager:ResourceManager)
		{
			this._resourceManager = resourceManager;
		}
		
		public function changeLoaderInfo(resourceLoaderData:ResourceLoaderData, progressCallback:Function, completeCallback:Function):void
		{
			this._resourceLoaderData = resourceLoaderData;
			this._progressCallback = progressCallback;
			this._completeCallback = completeCallback;
			
			if(this._loader != null){
				this.removeEvent();
				this._loader = null;
			}
			
			this._loader = new Loader();
			this.addEvent();
			
			var urlRequest:URLRequest = new URLRequest(this._resourceLoaderData.path);
			this._loader.load(urlRequest, SWFSecurityUtil.requestSWFLoaderContext(false, true));
		}
		
		private function addEvent() : void
		{
			var loaderInfo:LoaderInfo = _loader.contentLoaderInfo;
			if (!loaderInfo.hasEventListener(Event.COMPLETE))
			{
				loaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			}
			if (!loaderInfo.hasEventListener(ProgressEvent.PROGRESS))
			{
				loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			}
			if (!loaderInfo.hasEventListener(HTTPStatusEvent.HTTP_STATUS))
			{
				loaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
			}
			if (!loaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))
			{
				loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			}
			if (!loaderInfo.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
			{
				loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			}
		}
		
		private function onCompleteHandler(eventHandler:Event):void
		{
			this._resourceLoaderData.loaderInfo = this._loader.contentLoaderInfo;
			
			this._resourceManager.addResource(this._resourceLoaderData);
			
			if(this._completeCallback is Function){
				this._completeCallback(this._resourceLoaderData);
			}
		}
		
		private function onProgressHandler(eventHandler:ProgressEvent):void
		{
			if(this._progressCallback is Function){
				this._progressCallback(this._resourceLoaderData.key, eventHandler.bytesLoaded, eventHandler.bytesTotal);
			}
		}
		
		private function onHttpStatusHandler(eventHandler:HTTPStatusEvent):void
		{
		}
		
		private function onIOErrorHandler(eventHandler:IOErrorEvent):void
		{
			if(this._completeCallback is Function){
				this._completeCallback(null);
			}
		}
		
		private function onSecurityErrorHandler(eventHandler:SecurityErrorEvent):void
		{
		}
		
		private function removeEvent() : void
		{
			Log.debug("ProgressEvent removed");
			var loaderInfo:LoaderInfo  = _loader.contentLoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			loaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onSecurityErrorHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
		}
	}
}