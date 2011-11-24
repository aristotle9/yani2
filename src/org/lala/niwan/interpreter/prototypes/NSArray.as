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
        
        public function index(self:Array, i:uint):*
        {
            return self[i];
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