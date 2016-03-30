package
{
	import com.asset.xml.NodeObject;

	public class Config
	{
		public static var pukeArr:Array;
		public static const LONGHUDOU:String = "龙虎斗";
		public static const BAIJIALE:String = "百家乐";
		public static const DEZHOUBUPUKE:String = "德州扑克";
		public static var gameTypeArr:Array = ["百家乐","龙虎斗","德州扑克"];
		public static var playerObj:Object ={"龙虎斗":["龙","虎"]};
		public static var wanfa:NodeObject;//存储所有游戏的玩法;
		public function Config()
		{
			
		}
	}
}