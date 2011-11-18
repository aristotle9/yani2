package org.lala.niwan.interpreter.runtime
{
    public class ArgItem
    {
        public static const NULL:ArgItem = new ArgItem();
        public static const DEFAULT:ArgItem = new ArgItem();
        
        private var _name:String;
        private var _value:*;
        
        public function ArgItem(name:String=null, value:*=null)
        {
            _name = name;
            _value = value;
        }

        public function get name():String
        {
            return _name;
        }

        public function get value():*
        {
            return _value;
        }


    }
}