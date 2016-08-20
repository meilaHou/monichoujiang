package com.wg.resource
{
	import flash.display.LoaderInfo;

	public class ResourceLoaderData
	{
		public var key:String;
		
		public var path:String;
		
		public var loaderInfo:LoaderInfo;
		
		public function ResourceLoaderData(path:String, key:String = "")
		{
			this.path = path;
			
			if(key == null || key == ""){
				this.key = path;
			}else{
				this.key = key;
			}
		}
	}
}