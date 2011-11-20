package org.lala.niwan.interpreter.runtime
{
    import org.lala.niwan.interpreter.VirtualMathine;

    public class NSUnitFunction extends NSFunction
    {
        /** 属性函数:对属性求值时立即执行的无参函数 **/
        public function NSUnitFunction(functionName:String, functionEntity:Function)
        {
            super(functionName, functionEntity);
        }
        
        /** vm的self的实际已经在外部绑定 **/
        override public function apply(vm:VirtualMathine, paramsArray:Array):*
        {
            return _func.apply();
        }
    }
}