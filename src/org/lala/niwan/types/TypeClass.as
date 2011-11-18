package org.lala.niwan.types
{
    import flash.utils.getQualifiedClassName;

    public class TypeClass
    {
        public static const NumberType:TypeClass = new TypeClass('number');
        public static const StringType:TypeClass = new TypeClass('string');
        public static const BooleanType:TypeClass = new TypeClass('boolean');
        public static const ArrayType:TypeClass = new TypeClass('array');
        public static const ObjectType:TypeClass = new TypeClass('object');
        public static const UnitType:TypeClass = new TypeClass('unit');
        public static const AnyType:TypeClass = new TypeClass('any');
        public static const FunctionType:TypeClass = new TypeClass('function');
        public static const LambdaType:TypeClass = new TypeClass('lambda');
        protected var _name:String; 
        public function TypeClass(name:String)
        {
            _name = name;
        }
        
        public function toString():String
        {
            return getQualifiedClassName(this);
        }

        public function get name():String
        {
            return _name;
        }

        public function set name(value:String):void
        {
            _name = value;
        }

    }
}