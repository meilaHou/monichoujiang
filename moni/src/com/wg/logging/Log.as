package com.wg.logging 
{
	public class Log 
	{
		public static const ALL_LEVEL:String = "*";
		
		public static const LEVEL:Object = {
			'trace': 'TRACE',
			'debug': 'DEBUG',
			'info': 'INFO',
			'warn': 'WARN',
			'error': 'ERROR',
			'fatal': 'FATAL',
			'profiler': 'PROFILER',
			'parentLevel':'parentLevel'
		};
		
		public static const LOGGER:Object = {
			'TraceLogger': TraceLogger,
			"ConsoleLogger" : ConsoleLogger
		};
		
		private static var _instance:Log;
		
		private var _levelToLoggers:Object = { };
		
		public static function get instance() : Log
		{
			if (_instance == null) {
				_instance = new Log;
			}
			return _instance;
		}
		
		public var enable:Boolean = true;
		
		//Log filter format{level:[XXX, XXX, XXX], func:[XXX, XXX, XXX], content:[XXX, XXX, XXX]}
		private var _filters:Object = null;
		private var _sourceFilters:Object = null;
		
		public function set filters(value:Object):void
		{
			_filters = value;
			_sourceFilters = cloneFilter(_filters);
		}
		
		private function cloneFilter(filters:Object):Object
		{
			var result:Object = null;
			
			if(filters)
			{
				result = {};
				
				for(var key:String in filters)
				{
					result[key] = filters[key].concat();
				}
			}
			
			return result;
		}
		
		public function appendFilter(filter:Object/*{level:XXX, func:XXX, content:XXX}*/):void
		{
			if(!_filters || !filter)
				return;
			
			for(var key:String in filter)
			{
				if(!_filters.key)
					_filters.key = [];
				
				_filters.key.push(filter[key]);
			}
		}

		public function resetFilters():void
		{
			_filters = cloneFilter(_sourceFilters);
		}
		
		public static function trace(... args) : void
		{
			instance.log('trace', args);
		}
		
		public static function debug(... args) : void
		{
			instance.log('debug', args);
		}
		
		public static function info(... args) : void
		{
			instance.log('info', args);
		}
		
		public static function warn(... args) : void
		{
			instance.log('warn', args);
		}
		
		public static function error(... args) : void
		{
			instance.log('error', args);
		}
		
		public static function fatal(... args) : void
		{
			instance.log('fatal', args);
		}
		
		public static function profiler(... args) : void
		{
			instance.log('profiler', args);
		}
		public static function parentLevel(... args):void
		{
			instance.log('parentLevel', args);
		}
		
		public static function log(level:String, args:Array) : void
		{
			instance.log(level, args);
		}
		
		public function init(config:*=null) : void
		{
			if (config == null) {
				return;
			}
			
			var configObject:Object = config as Object;
			for each (var elem:Object in configObject.loggers) {
				if (LOGGER[elem.name] == null) {
					continue;
				}
				
				var levels:Array = [];
				if (elem.levels == ALL_LEVEL) {
					for (var l:String in LEVEL) {
						levels.push(l);
					}
				}
				else {
					levels = elem.levels.split(/\W+/);//匹配任何非单词字符。等价于“[^A-Za-z0-9_]”。+号代表多次匹配非单词字符;
				}
				
				//elem.params 属性中stage 在app 中赋值;
				var logger:ILogger = new (LOGGER[elem.name] as Class)(elem.params);	
				
				for (var i:uint = 0; i < levels.length; ++i) {
					if (levels[i]) {
						this.addLogger(levels[i], logger);
					}
				}
			}			
		}
		
		public function addLogger(level:String, logger:ILogger) : void
		{
			if (this._levelToLoggers[level] == null) {
				this._levelToLoggers[level] = new Array;
			}
			this._levelToLoggers[level].push(logger);
		}
		
		public function log(level:String, args:Array) : void
		{
			if(!enable)
				return;
			
			if (this._levelToLoggers[level] == null) {
				return;
			}
			
			try {
				
				var stackTrace:String = new Error().getStackTrace();
				var func:String = "??";
				var line:String = "??";
				
				if (stackTrace) {
					do {
						var stacks:Array = stackTrace.split("\n", 5);
						if (stacks.length < 4) {
							break;
						}
						
						// 获取第 3 个调用  frame，
						// 第 1 个是自己
						// 第 2 个是 debug/warn/error/...
						// 第 3 个是真正的业务逻辑函数
						//第4个是引用业务逻辑函数的类
						var stack:String ;
						if(level=="parentLevel")
						{
							stack = stacks[4];
						}else
						{
							stack = stacks[3];
						}
						
						// 函数名[文件名:行数]
						var tmp:Array = stack.split('[', 2);
						
						// 提取函数名
						func = (tmp[0].split(' ') as Array).pop();
						if (tmp.length < 2) {
							break;
						}
						
						// 提取行号
						var s:String = (tmp[1].split(':') as Array).pop();
						line = s.split(']').shift();
					} while(0);
				}
				
				if(!checkPassFilters(level, func, args))
					return;
				
				var logInfo:Object = {
					level: level,
					func: func,
					line: line,
					data: args,
					date: new Date()
				};
				
				var loggers:Array = this._levelToLoggers[level];
				for (var i:int=0; i<loggers.length; ++i) {
					try {
						(loggers[i] as ILogger).log(logInfo);
					}
					catch (e:*) {
						//ignore
					}
				}
			}
			catch (e:*) {
				//ingore
			}
		}
		
		private function checkPassFilters(targetLevel:String, targetFunc:String, targetContents:Array):Boolean
		{
			//level filter
			for (var key:String in _filters)
			{
				switch(key)
				{
					case "level":
						if(!checkPassFiltersByLevel(targetLevel, _filters.level))
							return false;
						break;
					
					case "func":
						if(!checkPassFiltersByFunc(targetFunc, _filters.func))
							return false;
						break;
					
					case "content":
						if(!checkPassFiltersByContents(targetContents, _filters.content))
							return false;
						break;
				}
			}
			
			return true;
		}
		
		private function checkPassFiltersByLevel(targetLevel:String, filtersLevels:Array):Boolean
		{
			if(targetLevel && targetLevel.length)
				targetLevel = targetLevel.toLowerCase();
			
			for each(var key:String in filtersLevels)
			{
				if(targetLevel.indexOf(key) != -1)
					return false;
			}
			
			return true;
		}
		
		private function checkPassFiltersByFunc(targetFunc:String, filterFuncs:Array):Boolean
		{
//			if(targetFunc && targetFunc.length)
//				targetFunc = targetFunc.toLowerCase();
			
			for each(var key:String in filterFuncs)
			{
				if(targetFunc.indexOf(key) != -1)
					return false;
			}
			
			return true;
		}
		
		private function checkPassFiltersByContents(targetContents:Array, filterContents:Array):Boolean
		{
			for each(var key:String in filterContents)
			{
				for each(var tKey:String in targetContents)
				{
					if(tKey.indexOf(key) != -1)
						return false;
				}
			}
			
			return true;
		}
	}
}