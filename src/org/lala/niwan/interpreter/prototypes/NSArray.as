package org.lala.niwan.interpreter.prototypes
{
    import org.lala.niwan.interpreter.interfaces.IProto;
    import org.lala.niwan.interpreter.runtime.NSLambdaFunction;

    public class NSArray extends NSObject
    {
        protected static const _instance:NSArray = new NSArray;
        public function NSArray()
        {
            super();
        }
        
        public static function getInstance():NSArray
        {
            return _instance;
        }
        
        override public function get proto():IProto
        {
            return NSObject.getInstance()
        }
        
        public function size(self:Array):uint
        {
            return self.length;
        }
        
        public function index(self:Array, i:int):*
        {
            if(i >= 0 && i < self.length)
                return self[i];
            else
                return null;
        }
        
        public function sort(self:Array):Array
        {
            self.sort();
            return self;
        }
        
        public function sum(self:Array):*
        {
            var res:Number = 0;
            self.forEach(function(a:*, ...args):void
            {
                res += a;
            });
            return res;
        }
        
        public function product(self:Array):Number
        {
            var res:Number = 1;
            self.forEach(function(a:*, ...args):void
            {
                res *= Number(a);
            });
            return res;
        }
        
        public function map(self:Array, func:NSLambdaFunction):Array
        {
            return self.map(function(a:*, i:uint, p:Array):*
            {
                return func.call({'self':self, '@0':a, '@1':i, '@2':p});
            });
        }
    }
}