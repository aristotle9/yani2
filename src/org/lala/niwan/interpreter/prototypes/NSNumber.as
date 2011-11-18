package org.lala.niwan.interpreter.prototypes
{
    import org.lala.niwan.interpreter.interfaces.IProto;
    import org.lala.niwan.interpreter.runtime.NSLambdaFunction;

    public dynamic class NSNumber extends NSObject
    {
        protected static const _instance:NSNumber = new NSNumber;
        
        public function NSNumber()
        {
            super();
        }
        
        override public function get proto():IProto
        {
            return NSObject.getInstance()
        }
        
        public static function getInstance():NSNumber
        {
            return _instance;
        }
        
        public function sin(self:Number):Number
        {
            return Math.sin(self);
        }
        
        public function cos(self:Number):Number
        {
            return Math.cos(self);
        }
        
        public function tan(self:Number):Number
        {
            return Math.tan(self);
        }
        
        public function abs(self:Number):Number
        {
            return Math.abs(self);
        }
        
        public function floor(self:Number):Number
        {
            return Math.floor(self);
        }
        
        public function ceil(self:Number):Number
        {
            return Math.ceil(self);
        }
        
        public function plus(self:Number):Number
        {
            return self;
        }
        
        public function minus(self:Number):Number
        {
            return - self;
        }
        
        public function bitNot(self:Number):Number
        {
            return ~ self;
        }
        
        public function increase(self:Number):Number
        {
            return self + 1;
        }
        
        public function decrease(self:Number):Number
        {
            return self - 1;
        }
        
        public function pow(self:Number, y:Number):Number
        {
            return Math.pow(self, y);
        }
        
        public function add(self:Number, y:Number):Number
        {
            return self + y;
        }
        
        public function subtract(self:Number, y:Number):Number
        {
            return self - y;
        }
        
        public function multiply(self:Number, y:Number):Number
        {
            return self * y;
        }
        
        public function divide(self:Number, y:Number):Number
        {
            return self / y;
        }
        
        public function modulo(self:Number, y:Number):Number
        {
            return self % y;
        }
        
        public function times(self:Number, func:NSLambdaFunction):Number
        {
            if(self <= 0)
            {
                return self;
            }
            var i:uint = 0;
            while(i < self)
            {
                func.call({'@0':i, 'self':self});
                i ++;
            }
            return self;
        }
    }
}