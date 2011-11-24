package org.lala.niwan.interpreter.adapters
{
    import flash.utils.setTimeout;
    
    import org.lala.niwan.interpreter.VirtualMathine;
    import org.lala.niwan.interpreter.runtime.ArgItem;
    import org.lala.niwan.interpreter.runtime.Exprs;
    import org.lala.niwan.interpreter.runtime.NSNodeFunction;
    
    public final class TheTimerFunction extends NSNodeFunction
    {
        public function TheTimerFunction()
        {
            super('timer', createTimer);
            
            pushArgs(['timer', ArgItem.NULL]);//秒
            pushArgs(['then', null]);
        }
        
        private function createTimer(vm:VirtualMathine, params:Object):*
        {
            var thenExpr:Exprs = params['then'] as Exprs; 
            if(thenExpr === null)
            {
                return null;
            }
            
            var timerExpr:Exprs = params['timer'] as Exprs;
            var timer:Number = Number(timerExpr.eval());
                
            var tm:uint = setTimeout(function():void
            {
                thenExpr.eval();                
            }, timer * 1000);
            return tm;
        }
    }
}