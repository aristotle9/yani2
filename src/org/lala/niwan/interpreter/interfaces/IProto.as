package org.lala.niwan.interpreter.interfaces
{
    /** 原型接口 **/
    public interface IProto
    {
        /** 原型链的上一层 **/
        function get proto():IProto;
        /** 查找名为attr的属性,并返回内部引用 **/
        function getSlot(self:*, attr:String):*
        /** 检测是否有名为attr的属性 **/
        function hasSlot(self:*, attr:String):Boolean;
        /** 对消息求值 **/
        function __send(self:*, attri:String, args:Array=null):*;
    }
}