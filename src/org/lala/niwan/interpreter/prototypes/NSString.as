package org.lala.niwan.interpreter.prototypes
{
    import org.lala.niwan.interpreter.Evaluator;
    import org.lala.niwan.interpreter.interfaces.IProto;

    public class NSString extends NSObject
    {
        protected static const _instance:NSString = new NSString;
        public function NSString()
        {
            super();
        }
        
        public static function getInstance():NSString
        {
            return _instance;
        }
        
        override public function get proto():IProto
        {
            return NSObject.getInstance()
        }
        
        public function index(self:String, i:int):String
        {
            if(i < self.length && i >= 0)
            {
                return self.charAt(i);
            }
            else
            {
                return null;
            }
        }
        
        public function size(self:String):uint
        {
            return self.length;
        }
        
        public function indexOf(self:String, key:String, from:int=0):int
        {
            return self.indexOf(key, from);   
        }
        
        public function slice(self:String, from:int, length:int):String
        {
            return self.substr(from, length);
        }
        
        public function toInteger(self:String):int
        {
            if(self.length > 1 && self.charAt() == '0' && self.charAt(1).toLowerCase() != 'x')
            {
                return parseInt(self, 8);
            }
            return parseInt(self);
        }
        
        public function toFloat(self:String):Number
        {
            return parseFloat(self);
        }
        
        public function eval(self:String):*
        {
            //可能寻求重用外部的求值器,定义域问题也必须关注
            //如果定义成ns系列函数,可以使用vm的scope+新的求值器
            var ev:Evaluator = new Evaluator();
            if(self.charAt() !== '/')
            {
                self = '/' + self;
            }
            return ev.evalSource(self);
        }
    }
}