package org.lala.niwan.interpreter.runtime
{
    import org.lala.niwan.interpreter.VirtualMathine;
    import org.lala.niwan.interpreter.interfaces.IContext;
    import org.lala.niwan.interpreter.interfaces.INSFunction;
    
    public class NSFunction implements INSFunction
    {
        protected var _args:Vector.<ArgItem> = new Vector.<ArgItem>;
        protected var _name:String;
        /** 实体函数 **/
        protected var _func:Function;
        public function NSFunction(functionName:String, functionEntity:Function)
        {
            _name = functionName;
            _func = functionEntity;
        }
        
        public function call(paramsObject:Object):*
        {
            return _func.call(null, paramsObject);
        }
        
        public function apply(vm:VirtualMathine, paramsArray:Array):*
        {
            return _func.call(null, vm, paramsArray);
        }
        
        public function pushArgs(...args):void
        {
            var i:int = 0;
            var len:uint = args.length;
            for(; i < len; i ++)
            {
                if(i > 0 && args[i][1] == ArgItem.NULL && args[i - 1][1] != ArgItem.NULL)
                {
                    throw new Error("具有默认值的形式参数必须放在无默认值的形式参数之后.");
                }
                _args.push(new ArgItem(args[i][0], args[i][1]));
            }
        }
    }
}