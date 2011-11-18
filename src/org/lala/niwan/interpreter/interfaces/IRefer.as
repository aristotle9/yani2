package org.lala.niwan.interpreter.interfaces
{
    /** 脚本求值结果的引用类型 **/
    public interface IRefer extends IResult
    {
        /** 引用类型特有的赋值方法 **/
        function setValue():void;
    }
}