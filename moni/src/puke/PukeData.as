package puke
{
	public class PukeData
	{
		private var _num:int;//1--13
		private var _huase:int;//0,红桃,1黑莓,2,红方,3,黑桃
		public function PukeData()
		{
			
		}

		public function get huase():int
		{
			return _huase;
		}

		/**
		 *一次设定后不可改变; 
		 * @param value
		 * 
		 */
		public function set huase(value:int):void
		{
			if(_huase) return;
			_huase = value;
		}

		public function get num():int
		{
			return _num;
		}

		public function set num(value:int):void
		{
			if(_num) return;
			_num = value;
		}

	}
}