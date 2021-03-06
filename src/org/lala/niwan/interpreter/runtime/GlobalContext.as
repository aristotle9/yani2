package org.lala.niwan.interpreter.runtime
{
    import org.lala.niwan.interpreter.VirtualMathine;
    import org.lala.niwan.interpreter.interfaces.IContext;
    import org.lala.niwan.interpreter.prototypes.NSArray;
    import org.lala.niwan.interpreter.prototypes.NSBoolean;
    import org.lala.niwan.interpreter.prototypes.NSNumber;
    import org.lala.niwan.interpreter.prototypes.NSObject;
    import org.lala.niwan.interpreter.prototypes.TheDotDefFunction;
    
    public class GlobalContext extends Context
    {
        private static var _instance:GlobalContext = new GlobalContext;
        public function GlobalContext()
        {
            var if_kari:NSNodeFunction = new NSNodeFunction('if_kari', function(vm:VirtualMathine, params:Object):*
            {
                if((params['when'] as Exprs).eval(vm))
                {
                    if(params['then'] != null)
                    {
                        return (params['then'] as Exprs).eval(vm);
                    }
                }
                else
                {
                    if(params['else'] != null)
                    {
                        return (params['else'] as Exprs).eval(vm);
                    }
                }
                return null;
            });
            if_kari.pushArgs(['when', ArgItem.NULL],['then', null],['else', null]);
            
            var while_kari:NSNodeFunction = new NSNodeFunction('while_kari', function(vm:VirtualMathine, params:Object):*
            {
                var res:* = null;
                while((params['when'] as Exprs).eval(vm))
                {
                    res = (params['do'] as Exprs).eval(vm);
                }
                return res;
            });
            while_kari.pushArgs(['when', ArgItem.NULL], ['do', ArgItem.NULL]);
            
            var def_kari:NSNodeFunction = new NSNodeFunction('def_kari', function(vm:VirtualMathine, params:Object):*
            {
                var fname:String = (params['name'] as Exprs).eval(vm);
                var lexical_scope:IContext = vm.scope;
                var ffunc:Function = function(params1:Object):*
                {
                    var ctx:IContext = lexical_scope.newContext(params1);
                    vm.pushScope(ctx);
                    
                    var res:* = (params['body'] as Exprs).eval(vm);
                    
                    vm.popScope();
                    return res;
                };
                
                var deffunc:NSDefKariFunction = new NSDefKariFunction(fname, ffunc);
                lexical_scope.setV(fname, deffunc);
                
                return deffunc;
            });
            def_kari.pushArgs(["name", ArgItem.NULL], ["body", ArgItem.NULL]);
            
            var _at:NSFunction = new NSFunction('@', function(vm:VirtualMathine, paramsArray:Array):*
            {
                //[[null,exprs] ...
                paramsArray.some(function(a:Array, i:uint,...args):Boolean
                {
                    var exprs:Exprs = a[1];
                    if(exprs.from != exprs.to || exprs.codes[exprs.from][0] != 'loadV')
                    {
                        throw new Error("@函数的参数有误.");
                        return true;
                    }
                    else
                    {
                        var name:String = exprs.codes[exprs.from][1];
                        if(vm.scope.currentObject.hasOwnProperty('@' + i))
                        {
                            vm.scope.currentObject[name] = vm.scope.currentObject['@' + i]
                            return false;
                        }
                        else
                        {
                            throw new Error("@函数要绑定的id个数超过了lambda函数的参数个数.");
                            return true;
                        }
                    }
                });
            });
            
            var rand:Function = function(obj:*):Object
            {
                if(obj is String)
                {
                    var str:String = obj as String;
                    return str.charAt(Math.floor(Math.random() * str.length));
                }
                else
                {
                    if((Number(obj) - Math.floor(Number(obj))) == 0)
                        return Math.floor(Math.random() * Number(obj));
                    else
                        return Math.random() * Number(obj);
                }
            };
              
            var distance:Function = function(x1:Number, y1:Number, x2:Number, y2:Number):Number
            {
                return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
            };
            
            var obj:Object = {
                'trace':function(str:*):void{trace(str);},
                'Math':Math,
                'if_kari':if_kari,
                'if':if_kari,
                'while_kari':while_kari,
                'while':while_kari,
                'def_kari':def_kari,
                'rand':rand,
                'distance':distance,
                '@':_at
            };
            obj['def'] = new TheDotDefFunction(obj);
            
            //原型
            obj['Object'] = NSObject.getInstance();
            obj['Number'] = NSNumber.getInstance();
            obj['Array'] = NSArray.getInstance();
            obj['Boolean'] = NSBoolean.getInstance();
            
            super(obj, null);
        }
        
        public static function getInstance():IContext
        {
            return _instance;
        }
        
        override public function find(id:String):Boolean
        {
            if(this._object.hasOwnProperty(id) == false)
            {
                this._object[id] = null;
            }
            return true;
        }
    }
}