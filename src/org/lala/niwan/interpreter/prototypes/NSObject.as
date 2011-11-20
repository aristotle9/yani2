package org.lala.niwan.interpreter.prototypes
{
    import org.lala.niwan.interpreter.interfaces.INSFunction;
    import org.lala.niwan.interpreter.interfaces.IProto;
    import org.lala.niwan.interpreter.runtime.NSUnitFunction;

    /**
    * 对象对象的原型
    * <pre>
    * 原型链用来查找对象的属性,原型链之间不必有as3中的继承关系
    * 原型链使用 proto 属性查找
    * 一种对象的原型只有一个实例
    * </pre>
    **/
    public dynamic class NSObject implements IProto
    {
        protected static const _instance:NSObject = new NSObject;
        protected var _def:INSFunction = new TheDotDefFunction(this);
        
        public function NSObject()
        {
        }
        
        public static function getInstance():NSObject
        {
            return _instance;
        }
        
        public function get proto():IProto
        {
            return null;
        }
        
        public function get def():INSFunction
        {
            return _def;    
        }
        
        public function __send(self:*, attri:String, args:Array=null):*
        {
            args == null ? (args = []) : false;
            if(this.hasSlot(this, attri))
            {
                //当用def定义lazy属性的函数时,返回函数本身
                if(getSlot(this, attri) is INSFunction && !(getSlot(this, attri) is NSUnitFunction))
                {
                    return getSlot(this, attri);
                }
                return this[attri].apply(null, [self].concat(args));
            }
            else if(this.proto != null)
            {
                return this.proto.__send.call(null, self, attri, args);
            }
            else 
            {
                return null;
            }
        }
        /** 可以使用枚举方法显示限定的api **/
        public function hasSlot(self:*, attri:String):Boolean
        {
            return Object(self).hasOwnProperty(attri);
        }
        
        public function getSlot(self:*, attri:String):*
        {
            return self[attri];
        }
    }
}