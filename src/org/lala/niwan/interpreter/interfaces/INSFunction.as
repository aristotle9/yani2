package org.lala.niwan.interpreter.interfaces
{
    import org.lala.niwan.interpreter.VirtualMathine;

    public interface INSFunction
    {
        /** 分情况调用call与apply,不能同时使用两个方法 **/
        function call(paramsObject:Object):*;
        /**
         * paramArray : [[name,exprs], [name,exprs], [name,exprs]]
         **/
        function apply(vm:VirtualMathine, paramsArray:Array):*;
        /**
         * [n,v], [n,v], [n,v], [n,v]
         **/
        function pushArgs(...args):void;
    }
}