package org.lala.niwan.interpreter.prototypes
{
    import org.lala.niwan.interpreter.VirtualMathine;
    import org.lala.niwan.interpreter.interfaces.IContext;
    import org.lala.niwan.interpreter.interfaces.INSFunction;
    import org.lala.niwan.interpreter.runtime.ArgItem;
    import org.lala.niwan.interpreter.runtime.Exprs;
    import org.lala.niwan.interpreter.runtime.NSLambdaFunction;
    import org.lala.niwan.interpreter.runtime.NSNodeFunction;
    import org.lala.niwan.interpreter.runtime.NSUnitFunction;
    
    public class TheDotDefFunction extends NSNodeFunction
    {
        private var _parent:Object;
        
        public function TheDotDefFunction(parent:Object)
        {
            _parent = parent;
            super(parent.toString() + '.def', def);
            
            this.pushArgs(['name', ArgItem.NULL]);
            this.pushArgs(['script', ArgItem.NULL]);
            this.pushArgs(['lazy', false]);//用于当无参数情况下,省略括号调用(false)与否(true)
        }
        /**
        * 为parent添加一个名称为func_name的脚本函数对象属性,作为parent的一个自定义方法
        **/
        private function def(vm:VirtualMathine, params:Object):INSFunction
        {
            var func_name:String;
            var func_body:INSFunction;
            
            var nameExp:Exprs = params['name'];
            var scriptExp:Exprs = params['script'];
            var lazy:Boolean;
            if(params['lazy'] is Exprs)
            {
                lazy = Boolean((params['lazy'] as Exprs).eval(vm));
            }
            else
            {
                lazy = params['lazy'];
            }
            
            //单个name时,为一条指令的Exprs,[loadV,"id"]
            if(nameExp.from == nameExp.to)
            {
                //函数名称提取
                func_name = nameExp.codes[nameExp.from][1];
                //函数定义
                if(lazy)
                {
                    func_body = new NSLambdaFunction('.' + func_name,
                        function(params:Object):*//按规定,参数值为空,但是不排除使用@num引用后来才传入的参数
                        {
                            //如果已经有self参数,则内部无法调到为左值的self
                            if(! params.hasOwnProperty('self'))
                            {
                                params['self'] = vm.scope.self;
                            }
                            var ctx:IContext = vm.scope.newContext(params);//需要绑定一个新的定义域,以承载局部变量
                            vm.pushScope(ctx);
                            try
                            {
                                return scriptExp.eval(vm);
                            }
                            catch(e:Error)
                            {
                                throw e;
                            }
                            finally
                            {
                                vm.popScope();
                            }
                        });
                }
                else
                {
                    func_body = new NSUnitFunction('.' + func_name,
                        function ():*//无括号调用时参数时必须为空
                        {
                            var ctx:IContext = vm.scope.newContext({self:vm.scope.self});//需要绑定一个新的定义域,以承载局部变量
                            vm.pushScope(ctx);
                            try
                            {
                                return scriptExp.eval(vm);
                            }
                            catch(e:Error)
                            {
                                throw e;
                            }
                            finally
                            {
                                vm.popScope();
                            }
                        });
                }
            }
            //绑定刚刚定义的参数
            _parent[func_name] = func_body;
            return func_body;
        }
    }
}