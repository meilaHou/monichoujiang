package com.asset.xml{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.xml.*;
  
	public class XmlToObject extends Sprite {
		private var mXml:XML = null;
		public static const XMLLOADCOMPELETE:String = "XMLLOADCOMPELETE";
		public function XmlToObject(url:String="",node:XML = null) {
			if(url)
			{
				var xmlload:XmlLoader = new XmlLoader(url,xmlReturnFunc);
			}
			if(node)
			{
				xmlReturnFunc(node);
			}
		}
		private var _xmlObject:NodeObject = new NodeObject();
		private var _xmlArray:Array = new Array();
		
		/*使用方法:id做键,同级id不可以重复;
		 * 读取属性:_xmlObject["urlqian"].attributes["id"];
		 * 获取子集Object:_xmlObject["imgQian"].child["img2"];
		 * 读取最终节点的value:获取子集Object:_xmlObject["imgQian"].child["img2"].value;如果不是最终节点,则返回此节点的名称.
		*   type保存节点名称;
		 * 没有子集,没有父类
		 * 没有子集,有父类
		 * 有子集,没有父类
		 * 有子集,有父类
		 * */

		/*
		 * 通过id访问节点的属性和值.
		 * 必要条件:xml中每个节点都要有id属性;同级节点id名称不能重复.
		 * */
		private function DecodeXmlById(results:XML,obj:NodeObject=null):void
		{
			if (!results.hasComplexContent())//判断是否拥有子集,这里为没有
			{
				if (obj == null)//如果没有子集,判断是否是某一节点的子集,这里为否
				{
					if(_xmlObject[String(results.@id)]== undefined) _xmlObject[String(results.@id)] = new NodeObject();
					_xmlObject[String(results.@id)].value = results;//最终节点,返回的是他的字符串内容.
					_xmlObject[String(results.@id)].type = results.name();
					if (results.attributes().length() > 0)
					{
						_xmlObject[String(results.@id)].attributes = new NodeObject();
						for(var i:int=0;i<results.attributes().length();i++)
						{
							_xmlObject[String(results.@id)].attributes[String(results.attributes()[i].name())] = results.attributes()[i];
						}
					}
				}else {//
					//trace(obj.child == undefined);
					if (!obj.child) {
						obj.child = new NodeObject();
					}else {
						//trace();
					}
					obj.child[String(results.@id)] = new NodeObject();
					//trace("##results.@id="+results.@id);
					obj.child[String(results.@id)].value = results;
					obj.child[String(results.@id)].type = results.name();
					if (results.attributes().length() > 0)//存储节点的属性键值对
					{
						
						obj.child[String(results.@id)].attributes = new NodeObject();
						
						for(var j:int=0;j<results.attributes().length();j++)
						{
							obj.child[String(results.@id)].attributes[String(results.attributes()[j].name())] = results.attributes()[j];
						}
					}
						
				}
			}else {//有子集的节点
				if (obj == null)
				{
					_xmlObject[String(results.@id)] = new NodeObject();
					_xmlObject[String(results.@id)].value = results.name() + "节点";
					_xmlObject[String(results.@id)].type = results.name();
					//trace("results.@id="+results.@id);
					if (results.attributes().length() > 0)//判断是否拥有属性
					{
						_xmlObject[String(results.@id)].attributes = new NodeObject();
						for(var k:int=0;k<results.attributes().length();k++)
						{
							_xmlObject[String(results.@id)].attributes[String(results.attributes()[k].name())] = results.attributes()[k];
						}
					}
					for each(var xmlChildren:XML in results.children())   
					{
						//trace("xml::"+results);
						//trace("xmlCihld::"+xmlChildren.@id);
						DecodeXmlById(xmlChildren,_xmlObject[String(results.@id)]);//传入上一级路径
					};
					
				}else {
					if (!obj.child) {
						obj.child = new NodeObject();
					}
					obj.child[String(results.@id)] = new NodeObject();
					obj.child[String(results.@id)].value = results.name() + "节点";
					obj.child[String(results.@id)].type = results.name();
					if (results.attributes().length() > 0)//判断是否拥有属性
					{
						obj.child[String(results.@id)].attributes = new NodeObject();
						for(k=0;k<results.attributes().length();k++)
						{
							obj.child[String(results.@id)].attributes[String(results.attributes()[k].name())] = results.attributes()[k];
						}
					}
					for each(xmlChildren in results.children())   
					{
						DecodeXmlById(xmlChildren,obj.child[String(results.@id)]);
					}
				}
				
			}
		}
		

		public function xmlReturnFunc(node:XML):void
		{
			var results:XMLList = node.children();
			//trace(results);//整个xml
			for each( var xmlChildren:XML in results)   
			{
				DecodeXmlById(xmlChildren);
			}
			this.dispatchEvent(new Event("XMLLOADCOMPELETE"));
			//trace(Global.configxml.xmlObject["home"].attributes["src"]);

/*			trace("trace:" + _xmlObject["imgQianid"].child["imgQian_2"].value);
			trace("trace:" + _xmlObject["imgQianid"].child["imgQian_1"].value);
			trace("trace:" + _xmlObject["imgShenids"].child["imgShenids_2"].child["4_1"].child["s"].child["ddd"].value);
			trace("trace:" + _xmlObject["imgShenids"].child["imgShenids_2"].value);
			trace("trace:" + _xmlObject["imgShenids"].child["imgShenids_1"].value);
			trace("trace:" + _xmlObject["imgShenids"].child["imgShenids_1"].type);
			trace("trace:" + _xmlObject["index"].child["nav"].child["game"].attributes["src"]);*/

		}
		
		
		public function traceObj(obj:NodeObject,names:String = ""):void
		{
			for(var o:* in obj)
			{
				var fatherName:String;
//				trace(typeof(obj[o]));
				if(!names) {
					//fatherName = "=========start  ";
					
				}else
				{
					fatherName = names;
				}
				if (typeof(obj[o]) != "NodeObject")
				{
					fatherName = names+":"+o;
				}
//				trace("==========start",o+":"+obj[o],"==========");
				if (typeof(obj[o]) == "NodeObject")
				{
					trace("\n");
					fatherName += "."+o;
					trace(fatherName,"start=========");
					traceObj(obj[o],fatherName);
					trace(fatherName,"end=========");
				}else
				{
					trace("",fatherName+":"+obj[o],"");
				}
				
				
			}
		}
		
		/**
		 * 暂无;
		 * @param type 根据某一属性进行排序;
		 * 
		 */
		public function sortOn(type:String,isUp:Boolean):Array
		{
			var arr:Array = new Array();
			return arr;
		}
		public function get xmlObject():NodeObject 
		{
			return _xmlObject;
		}
		
		
		
		
		
		/*		private function DecodeXmlByType(results:XML,obj:NodeObject=null):void
		{
		var newObj:NodeObject = {};
		if (!results.hasComplexContent())//判断是否拥有子集
		{
		if (obj == null)//如果没有子集,判断是否是某一节点的子集,这里为否
		{
		_xmlObject[String(results.name())] = new NodeObject();
		_xmlObject[String(results.name())].value = results;//最终节点,返回的是他的字符串内容.
		//					trace("hello::"+results.@id);
		//trace("results::" + _xmlObject["urlqian"].value);
		if (results.attributes().length() > 0)
		{
		_xmlObject[String(results.name())].attributes = new NodeObject();
		for(var i:int=0;i<results.attributes().length();i++)
		{
		_xmlObject[String(results.name())].attributes[String(results.attributes()[i].name())] = results.attributes()[i];
		//trace(results.attributes()[i].name()+"::"+_xmlObject[String(results.name())].attributes[String(results.attributes()[i].name())]);
		}
		}
		}else {//是某一节点的子集.
		obj.child = new NodeObject();
		obj.child[String(results.name())] = new NodeObject();
		obj.child[String(results.name())].value = results;
		//trace("results::" + results);
		//trace("results::" + obj.child[String(results.name())].value);
		if (results.attributes().length() > 0)//存储节点的属性键值对
		{
		obj.child[String(results.name())].attributes = new NodeObject();
		for(var j:int=0;j<results.attributes().length();j++)
		{
		obj.child[String(results.name())].attributes[String(results.attributes()[j].name())] = results.attributes()[j];
		//trace(results.attributes()[j].name()+"::"+obj.child[String(results.name())].attributes[String(results.attributes()[j].name())]);
		}
		}
		}
		}else {//有子集的节点
		//trace("parent::"+results.name());
		for each(var xmlChildren:XML in results.children())   
		{
		if(obj == null)//判断是否是第一层.
		{
		_xmlObject[String(results.name())] = new NodeObject();
		_xmlObject[String(results.name())].value = results.name() + "节点";
		if (results.attributes().length() > 0)//判断是否拥有属性
		{
		_xmlObject[String(results.name())].attributes = new NodeObject();
		for(var k:int=0;k<results.attributes().length();k++)
		{
		_xmlObject[String(results.name())].attributes[String(results.attributes()[k].name())] = results.attributes()[k];
		//trace(results.attributes()[k].name()+"::"+_xmlObject[String(results.name())].attributes[String(results.attributes()[k].name())]);
		}
		}
		//将父类的value和attributes转换为Object;
		DecodeXmlByType(xmlChildren,_xmlObject[String(results.name())]);//传入上一级路径
		//trace("ziji:name="+xmlChildren.name());
		}else//这里是某一节点下的子集拥有子集的情况.
		{
		obj.child = new NodeObject();
		obj.child[String(results.name())] = new NodeObject();
		obj.child[String(results.name())].value = results.name() + "节点";
		DecodeXmlByType(xmlChildren,obj.child[String(results.name())]);
		//trace("''''''"+String(results.name()));
		}
		}
		
		}
		}*/
	}
}
