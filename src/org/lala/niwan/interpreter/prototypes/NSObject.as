package org.lala.niwan.interpreter.prototypes
{
    import org.lala.niwan.interpreter.interfaces.IProto;

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
        
        public function __send(self:*, attri:String, args:Array=null):*
        {
            args == null ? (args = []) : false;
            if(this.hasSlot(this, attri))
            {
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