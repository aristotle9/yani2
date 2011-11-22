package org.lala.niwan.interpreter.prototypes
{
    import org.lala.niwan.interpreter.VirtualMathine;
    import org.lala.niwan.interpreter.interfaces.IContext;
    import org.lala.niwan.interpreter.interfaces.INSFunction;
    import org.lala.niwan.interpreter.runtime.ArgItem;
    import org.lala.niwan.interpreter.runtime.Exprs;
    import org.lala.niwan.interpreter.runtime.NSLambdaFunction;
    import org.lala.niwan.interpreter.runtime.NSNodeFunction;
    import org.lala.niwan.interpreter.runtime.NSNormalFunction;
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
            //用于当无参数情况下,省略括号调用(false)与否(true)
            this.pushArgs(['lazy', false]);
        }
        /**
        * 为parent添加一个名称为func_name的脚本函数对象属性
        * 作为parent的一个自定义方法
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
            if(nameExp.from != nameExp.to)
            {
                //合法性不加以检验
                /*
                a(b,c)
                ["3#", "pushnull"],
                ["4#", "exprs", 5, 5],
                ["5#", "loadV", "b"],
                ["6#", "pushnull"],
                ["7#", "exprs", 8, 8],
                ["8#", "loadV", "c"],
                ["9#", "loadV", "a"],
                ["10#", "call", 2],
                */
                //倒数第二个是函数名
                var index:int = nameExp.to - 1;
                func_name = nameExp.codes[index][1];
                //递减收集参数名,简单实现
                //对于有默认参数的要更加仔细解析,call命令的个数参数也是有用的
                var arg_name:Array = [];
                index --;
                while(index >= nameExp.from)
                {
                    arg_name.unshift(nameExp.codes[index][1]);
                    index -= 3;
                }
                //["b","c"]
                //定义函数体
                func_body = new NSNormalFunction('.' + func_name,
                    function(params:Object):*
                    {
                        if(!params.hasOwnProperty('self'))
                        {
                            params['self'] = vm.scope.self;
                        }
                        var ctx:IContext = vm.scope.newContext(params);
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
                //压入参数表
                arg_name.forEach(function(name:String,...args):void
                {
                    func_body.pushArgs([name, ArgItem.NULL]);
                });
                
            }//单个name时,为一条指令的Exprs,[loadV,"id"]
            else if(nameExp.codes[nameExp.from][0] == "loadV")
            {
                //函数名称提取
                func_name = nameExp.codes[nameExp.from][1];
                //函数定义
                if(lazy)
                {
                    func_body = new NSLambdaFunction('.' + func_name,
                    //按规定,参数值为空,但是不排除使用@num引用后来才传入的参数
                        function(params:Object):*
                        {
                            //如果已经有self参数,则内部无法调到为左值的self
                            if(! params.hasOwnProperty('self'))
                            {
                                params['self'] = vm.scope.self;
                            }
                            //需要绑定一个新的定义域,以承载局部变量
                            var ctx:IContext = vm.scope.newContext(params);
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
                            //需要绑定一个新的定义域,以承载局部变量
                            var params:Object = {self:vm.scope.self};
                            var ctx:IContext = vm.scope.newContext(params);
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