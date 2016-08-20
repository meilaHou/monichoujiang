package com.wg.resource
{
	import com.wg.logging.Log;
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;

	/**
	 * 加载swf,并保存起来,
	 * 提供通过class名称字符串获取类;
	 * @author Administrator
	 * 
	 */
	public class ResourceLoader
	{	
//		private static var _instance:ResourceLoader;
//		public static function getInstance():ResourceLoader
//		{
//			if(_instance == null) _instance = new ResourceLoader();
//			return _instance;
//		}
		
		private var _resourceManager:ResourceManager;
		private var _resourceLoaderInfo:ResourceLoaderInfo;
		
		private var _loaderList:Array = [];
		
		private var _callbackList:Array = [];
		private var _loaderStatus:Boolean = false;

		private var _delayResourceList:Array = [];
		
		public function ResourceLoader()
		{
			this._resourceManager = new ResourceManager();
			this._resourceLoaderInfo = new ResourceLoaderInfo(this._resourceManager);
		}
		
		public function load(loaderList:Array, progressCallback:Function, completeCallback:Function):void
		{
			this._loaderList = this._loaderList.concat(loaderList);
			
			if(this._callbackList == null) 
			{
				this._callbackList = [];
			}
			
			this._callbackList.push({"value" : loaderList, "progressCallback" : progressCallback, "completeCallback" : completeCallback});
			Log.trace("_callbackList"+ _callbackList);
			if(!this._loaderStatus){
				this.loadOne();
			}
		}
		
		private function getKey(list:Array):String
		{
			if(list == null || list.length == 0) return null;
			
			var key:String = "";
			
			for each(var item:ResourceLoaderData in list){
				key += item.key + ":";
			}
			
			return key;
		}
		
		private function getCallbackIndexByValue(keyValue:String):int
		{
			if(this._callbackList == null || this._callbackList.length == 0) return -1;
			
			var index:int = 0;
			for each(var item:Object in this._callbackList){
				for each(var itemData:ResourceLoaderData in item["value"] as Array){
					if(itemData.key == keyValue) return index;
				}
				index ++;
			}
			return index;
		}
		
		private function getCallbackKeyIndex(pathList:Array, keyValue:String):int
		{
			if(pathList == null || pathList.length == 0) return -1;
			
			var index:int = 0;
			for each(var item:ResourceLoaderData in pathList){
				if(item.key == keyValue) return index;
				index ++;
			}
			return -1;
		}
		
		public function getLoadData(path:String, key:String=""):ResourceLoaderData
		{
			return new ResourceLoaderData(path, key);
		}
		
		public function checkLoadData(path:String):Boolean
		{
			var imageLoaderData:ResourceLoaderData = this._resourceManager.getResource(path);
			
			if (imageLoaderData == null || imageLoaderData.loaderInfo == null) return false;
			
			return true;
		}
		
		public function getImage(path:String):Bitmap
		{
			var imageLoaderData:ResourceLoaderData = this._resourceManager.getResource(path);
			if (imageLoaderData == null || imageLoaderData.loaderInfo == null) {
				return null;
			}
			
			var bitmap:Bitmap = imageLoaderData.loaderInfo.content as Bitmap;
			if (bitmap == null) {
				return null;
			}
			
			return new Bitmap(bitmap.bitmapData.clone());
		}
		
		public function getContent(path:String):*
		{
			var imageLoaderData:ResourceLoaderData = this._resourceManager.getResource(path);
			if (imageLoaderData == null || imageLoaderData.loaderInfo == null) {
				return null;
			}
			
			var content:* = imageLoaderData.loaderInfo.content;
			if (content == null) {
				return null;
			}
			return content;
		}
		
		public function getClass(className:String, keyName:String = ""):Class
		{
			if(keyName == null || keyName == "") keyName = className;
			
			var imageLoaderData:ResourceLoaderData = this._resourceManager.getResource(keyName);
			if (imageLoaderData == null || imageLoaderData.loaderInfo == null) {
				Log.error("没有找到相关的键值对 "+"keyName:"+keyName,"className:"+className);
				return null;
			}
			var cls:Class = imageLoaderData.loaderInfo.applicationDomain.getDefinition(className) as Class;
			return cls;
		}
		
		public function getResourceLoaderData(className:String, keyName:String = ""):ResourceLoaderData
		{
			if(keyName == null || keyName == "") keyName = className;
			
			var imageLoaderData:ResourceLoaderData = this._resourceManager.getResource(keyName);
			if (imageLoaderData == null || imageLoaderData.loaderInfo == null) {
				return null;
			}
			
			return imageLoaderData;
		}
		
		private function loadOne():void
		{
			if (this._loaderList.length > 0) {
				this._loaderStatus = true;
				
				var resourceLoaderData:ResourceLoaderData = this._loaderList.pop() as ResourceLoaderData;
				if(resourceLoaderData == null){
					Log.error(resourceLoaderData.path+"或"+resourceLoaderData.key+" 没有找到");
					return;
				}
					
				var varData:ResourceLoaderData = this._resourceManager.getResource(resourceLoaderData.key);
				if(varData != null){
					
					this.validLoader(resourceLoaderData, false);
					this.loadOne();
				}
				else {
					var loaderIndex:int = this.getCallbackIndexByValue(resourceLoaderData.key);
					if(loaderIndex != -1){
						this._resourceLoaderInfo.changeLoaderInfo(resourceLoaderData, this._callbackList[loaderIndex]["progressCallback"], onCompleteCallback);
					}else{
						throw new Error(resourceLoaderData.key+"加载失败");
					}
				}
			}else{
				this._loaderStatus = false;
			}
		}
		
		private function validLoader(resourceLoaderData:ResourceLoaderData, status:Boolean = false):void
		{
			var loaderIndex:int = this.getCallbackIndexByValue(resourceLoaderData.key);
			if(loaderIndex != -1){
				
				if(!status){
					Log.debug("validLoader"+_callbackList[loaderIndex]);
					//trace("validLoader"+_callbackList[loaderIndex]);
					var progressCallback:Function = this._callbackList[loaderIndex]["progressCallback"] as Function;
					if(progressCallback != null){
//						progressCallback(resourceLoaderData.path, 1, 1);
						
						progressCallback(resourceLoaderData.path, 
							resourceLoaderData.loaderInfo ? resourceLoaderData.loaderInfo.bytesLoaded : 0,
							resourceLoaderData.loaderInfo ? resourceLoaderData.loaderInfo.bytesTotal : 100);
					}
				}
				
				var pathList:Array = this._callbackList[loaderIndex]["value"] as Array;
				if(pathList != null && pathList.length > 0){
					
					var keyIndex:int = this.getCallbackKeyIndex(pathList, resourceLoaderData.key);
					if(keyIndex != -1){
						
						pathList.splice(keyIndex, 1);
						this._callbackList[loaderIndex]["value"] = pathList;
						
						if(pathList.length == 0){
							this._callbackList[loaderIndex]["completeCallback"]();
							loadOneDelayComplete();
							this._callbackList.splice(loaderIndex, 1);
						}
						
					}else{
						throw new Error("");
					}
				}
			}else{
				throw new Error("");
			}
		}
		
		public function delayLoadResourceList(resourceList:Array):void
		{
			_delayResourceList = _delayResourceList.concat(resourceList);
			load([_delayResourceList.shift()],null,loadOneDelayComplete);
		}
		
		private function loadOneDelayComplete():void
		{
			if(_delayResourceList.length == 0) return;
			if(_loaderList.length == 0)
			{
				load([_delayResourceList.shift()],null,loadOneDelayComplete);
			}	
		}
		
		private function onCompleteCallback(resourceLoaderData:ResourceLoaderData):void
		{
			if(resourceLoaderData != null)
			{
				try
				{
					this.validLoader(resourceLoaderData, true);
				}
				catch(error:Error) {};
			}
			
			this.loadOne();
		}
		
		public function addLoadedResource(path:String,content:LoaderInfo = null, key:String = null):void
		{
			var resource:ResourceLoaderData = new ResourceLoaderData(path, key);
			resource.loaderInfo = content;
			
			_resourceManager.addResource(resource);
		}
		
		public function clear():void
		{
			if(this._resourceManager == null) return;
			if(this._resourceManager != null) this._resourceManager.clear();
			
			_callbackList = [];
			_loaderList = [];
			_delayResourceList = [];
		}
	}
}