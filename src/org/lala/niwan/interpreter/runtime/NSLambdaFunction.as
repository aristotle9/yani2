package org.lala.niwan.interpreter.runtime
{
    import org.lala.niwan.interpreter.VirtualMathine;

    public class NSLambdaFunction extends NSFunction
    {
        public function NSLambdaFunction(functionName:String, functionEntity:Function)
        {
            super(functionName, functionEntity);
        }
        
        override public function apply(vm:VirtualMathine, paramsArray:Array):*
        {
            var params:Object = {};
            
            var k:uint = 0;
            paramsArray.forEach(function(a:Array, i:uint, ...args):void
            {
                if(a[0] != null)
                {
                    params['@' + a[0]] = (a[1] as Exprs).eval(vm);
                }
                else
                {
                    params['@' + (k++)] = (a[1] as Exprs).eval(vm);
                }
            });
            
            return _func.call(null, params);
        }        
    }
}