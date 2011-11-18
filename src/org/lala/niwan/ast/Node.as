package org.lala.niwan.ast
{
    import org.lala.niwan.types.TypeClass;

    public class Node
    {
        protected var _type:TypeClass
        protected var _name:String;
        protected var _nodes:Array;
        protected var _attri:*;
        public function Node(name:String,type:TypeClass=null,...args)
        {
            _name = name;
            _type = type != null ? type : TypeClass.AnyType;
            _nodes = args;
        }
        
        public function get type():TypeClass
        {
            return _type;
        }

        public function set type(value:TypeClass):void
        {
            _type = value;
        }

        public function get name():String
        {
            return _name;
        }

        public function set name(value:String):void
        {
            _name = value;
        }

        public function get nodes():Array
        {
            return _nodes;
        }

        public function set nodes(value:Array):void
        {
            _nodes = value;
        }

        public function get attri():*
        {
            return _attri;
        }

        public function set attri(value:*):void
        {
            _attri = value;
        }


    }
}