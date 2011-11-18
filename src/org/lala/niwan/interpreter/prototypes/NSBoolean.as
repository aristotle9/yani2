package org.lala.niwan.interpreter.prototypes
{
    import org.lala.niwan.interpreter.VirtualMathine;
    import org.lala.niwan.interpreter.interfaces.INSFunction;
    import org.lala.niwan.interpreter.interfaces.IProto;
    import org.lala.niwan.interpreter.runtime.Exprs;
    import org.lala.niwan.interpreter.runtime.NSNodeFunction;

    public class NSBoolean extends NSObject
    {
        private static var _instance:NSBoolean = new NSBoolean;
        private var _alter:NSNodeFunction;
            
        public function NSBoolean()
        {
            super();
            this._alter = new NSNodeFunction('alternative',
                function(vm:VirtualMathine, params:Object):*
                {
                    if(vm.scope.self as Boolean)
                    {
                        return (params['then'] as Exprs).eval(vm);
                    }
                    else
                    {
                        return (params['else'] as Exprs).eval(vm);
                    }
                });
            this._alter.pushArgs(['then', null]);
            this._alter.pushArgs(['else', null]);
        }
        
        override public function get proto():IProto
        {
            return NSBoolean.getInstance();
        }
        
        public static function getInstance():NSBoolean
        {
            return _instance;
        }
        
        public function get alt():INSFunction
        {
            return _alter;   
        }
        
        public function get alternative():INSFunction
        {
            return _alter;   
        }
    }
}