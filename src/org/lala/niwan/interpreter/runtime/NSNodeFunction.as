package org.lala.niwan.interpreter.runtime
{
    import org.lala.niwan.interpreter.VirtualMathine;

    public class NSNodeFunction extends NSFunction
    {
        public function NSNodeFunction(functionName:String, functionEntity:Function)
        {
            super(functionName, functionEntity);
        }
        
        override public function apply(vm:VirtualMathine, paramsArray:Array):*
        {
            var params:Object = {};
            var names:Array = [];
            _args.forEach(function(itm:ArgItem, i:uint, ...args):void
            {
                params[itm.name] = itm.value;
                names[i] = itm.name;
            });
            
            paramsArray.forEach(function(a:Array, i:uint, ...args):void
            {
                if(a[0] == null)
                {
                    params[names[i]] = a[1];
                }
                else if(a[0] != ArgItem.DEFAULT)
                {
                    params[a[0]] = a[1];
                }
            });
            
            names.forEach(function(key:String,...args):void
            {
                if(params[key] == ArgItem.NULL)
                {
                    throw new Error("名称为:" + key + "的参数在定义时没有默认值,在调用时亦没有指定值.");
                }
            });
            
            return _func.call(null, vm, params);
        }
    }
}