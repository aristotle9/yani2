package org.lala.niwan.interpreter.interfaces
{
    /** 脚本的求值结果 **/
    public interface IResult
    {
        /** 结果的内部类型 **/
        function get type():uint;
        /** 求值 **/
        function getValue():*;
    }
}