package com.wg.resource
{
	public class ResourceManager
	{
		private var _resourceList:Vector.<ResourceLoaderData>;
		
//		private var _warResourceList:Vector.<ResourceLoaderData>;
		
//		private var _dungeonResourceList:Vector.<ResourceLoaderData>;
		
		public function addResource(resourceLoaderData:ResourceLoaderData):void
		{
			if(resourceLoaderData == null) return;
			
//			if(resourceLoaderData.key.indexOf("war/") != -1 && resourceLoaderData.key.indexOf("BattleResource") == -1) return this.addWarResource(resourceLoaderData);
//			if(resourceLoaderData.key.indexOf("map/dungeon") != -1) return this.addDungeonResource(resourceLoaderData);
			
			if(this._resourceList == null) this._resourceList = new Vector.<ResourceLoaderData>();
			
			var varData:ResourceLoaderData = this.getResource(resourceLoaderData.key);
			
			if(varData == null){
				this._resourceList.push(resourceLoaderData);
			}
		}
		
//		private function addWarResource(resourceLoaderData:ResourceLoaderData):void
//		{
//			if(this._warResourceList == null) this._warResourceList = new Vector.<ResourceLoaderData>();
//			
//			var varData:ResourceLoaderData = this.getWarResource(resourceLoaderData.key);
//			
//			if(varData == null){
//				this._warResourceList.push(resourceLoaderData);
//			}
//		}
		
//		private function addDungeonResource(resourceLoaderData:ResourceLoaderData):void
//		{
//			if(this._dungeonResourceList == null) this._dungeonResourceList = new Vector.<ResourceLoaderData>();
//			
//			var varData:ResourceLoaderData = this.getDungeonResource(resourceLoaderData.key);
//			
//			if(varData == null){
//				this._dungeonResourceList.push(resourceLoaderData);
//			}
//		}
		
		public function getResource(key:String):ResourceLoaderData
		{
//			if(key.indexOf("war/") != -1 && key.indexOf("BattleResource") == -1) return this.getWarResource(key);
//			if(key.indexOf("map/dungeon") != -1) return this.getDungeonResource(key);
			
			if(this._resourceList == null || this._resourceList.length == 0) return null;
			
			for each(var resourceLoaderData:ResourceLoaderData in this._resourceList){
				if(resourceLoaderData.key == key) return resourceLoaderData;
			}
			
			return null;
		}
		
//		private function getWarResource(key:String):ResourceLoaderData
//		{
//			if(this._warResourceList == null || this._warResourceList.length == 0) return null;
//			
//			for each(var resourceLoaderData:ResourceLoaderData in this._warResourceList){
//				if(resourceLoaderData.key == key) return resourceLoaderData;
//			}
//			
//			return null
//		}
//		
//		private function getDungeonResource(key:String):ResourceLoaderData
//		{
//			if(this._dungeonResourceList == null || this._dungeonResourceList.length == 0) return null;
//			
//			for each(var resourceLoaderData:ResourceLoaderData in this._dungeonResourceList){
//				if(resourceLoaderData.key == key) return resourceLoaderData;
//			}
//			
//			return null;
//		}
		
		public function clear():void
		{
//			if(this._warResourceList == null) return;
			
//			var len:int = this._warResourceList.length;
			
//			for(var index:int = 0; index < len; index ++){
//				
//				delete this._warResourceList[index];
//			}
			
//			this._warResourceList.splice(0, len);
			for each(var resourceLoaderData:ResourceLoaderData in _resourceList)
			{
				if(resourceLoaderData.loaderInfo && resourceLoaderData.loaderInfo.loader)
				{
					try
					{
						resourceLoaderData.loaderInfo.loader.close();
						resourceLoaderData.loaderInfo.loader.unload();	
					}
					catch(error:Error){};
					
				}
			}
			_resourceList = null;
		}
		
//		public function dungeonClear():void
//		{
//			if(this._dungeonResourceList == null) return;
//			
//			var len:int = this._dungeonResourceList.length;
//			
//			for(var index:int = 0; index < len; index ++){
//				
//				delete this._dungeonResourceList[index];
//			}
//			
//			this._dungeonResourceList.splice(0, len);
//		}
	}
}