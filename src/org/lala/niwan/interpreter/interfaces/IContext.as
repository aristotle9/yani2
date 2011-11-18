package org.lala.niwan.interpreter.interfaces
{
    public interface IContext
    {
        /** 上一层上下文 **/
        function get parent():IContext;
        /** 当前变量存储对象 **/
        function get currentObject():Object;
        /** 当前self指向 **/
        function get self():Object;
        function set self(value:Object):void;
        function setV(id:String, value:*):void;
        function getV(id:String):*;
        function find(id:String):Boolean;
        /** 新建一层scope **/
        function newContext(obj:Object):IContext;
    }
}