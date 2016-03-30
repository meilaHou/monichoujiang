package com.asset.xml
{
	/**
	 *支持修改数据;
	 * @author Allen
	 * 
	 */
	public dynamic class NodeObject extends Object
	{
		public var value:String;
		public var child:NodeObject;
		public var attributes:NodeObject;
		public function NodeObject()
		{
			super();
		}
		
		/**
		 * 获取当前节点拥有的子节点数量
		 * @return 
		 * 
		 */
		public function getChildNumber():uint
		{
			var num:uint ;
			for(var i:String in child)//遍历nodeobject中的所有对象; 仅遍历动态加入的变量;
			{
				num++;
			}
			return num;
		}
		
		/**
		 * 获取当前节点拥有的属性的数量;
		 * @return 
		 * 
		 */
		public function getattributesNumber():uint
		{
			var num:uint ;
			for(var i:String in attributes)//遍历nodeobject中的所有对象; 仅遍历动态加入的变量;
			{
				num++;
			}
			return num;
		}
	}
}