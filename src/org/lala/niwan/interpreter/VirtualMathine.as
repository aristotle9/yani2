package org.lala.niwan.interpreter
{
    import org.lala.niwan.interpreter.interfaces.IContext;
    import org.lala.niwan.interpreter.interfaces.INSFunction;
    import org.lala.niwan.interpreter.interfaces.IProto;
    import org.lala.niwan.interpreter.prototypes.NSArray;
    import org.lala.niwan.interpreter.prototypes.NSBoolean;
    import org.lala.niwan.interpreter.prototypes.NSNumber;
    import org.lala.niwan.interpreter.prototypes.NSObject;
    import org.lala.niwan.interpreter.prototypes.NSString;
    import org.lala.niwan.interpreter.runtime.ArgItem;
    import org.lala.niwan.interpreter.runtime.Context;
    import org.lala.niwan.interpreter.runtime.Exprs;
    import org.lala.niwan.interpreter.runtime.GlobalContext;
    import org.lala.niwan.interpreter.runtime.NSLambdaFunction;
    import org.lala.niwan.interpreter.runtime.NSUnitFunction;

    public class VirtualMathine
    {
        private var _stack:Array = [];
        private var _codes:Array;
        private var _scope:IContext;
        private var _pc:uint;
        
        private var _scopeStack:Vector.<IContext> = new Vector.<IContext>;
        
        public function VirtualMathine(scope:IContext)
        {
            _scope = scope;
        }
        
        public function set codes(value:Array):void
        {
            _codes = value.slice();
            reset();
        }
        
        private function reset():void
        {
            _stack = [];
            _pc = 0;
        }
        
        public function pushScope(ctx:IContext):void
        {
            _scopeStack.push(_scope);
            _scope = ctx;
        }
        
        public function popScope():IContext
        {
            var res:IContext = _scope;
            _scope = _scopeStack.pop();
            return res;
        }
        
        public function run(codes:Array=null):*
        {
            if(codes == null)
                codes = _codes;
            return run_range(codes, 0, _codes.length - 1);
        }
        
        public function run_range(codes:Array, from:uint, to:uint):*
        {
            var pc:uint = _pc;
            var stack:Array = _stack;
            var r_codes:Array = _codes;
            
            
           _pc = from;
           _stack = [];
           _codes = codes;
           while(_pc <= to)
           {
               var op:Array = _codes[_pc];
               this['OP_' + op[0]](op);
           }
           var res:* = _stack.pop();
           
           _pc = pc;
           _stack = stack;
           _codes = r_codes;
           
           return res; 
        }
        
        private function OP_push(code:Array):void
        {
            _stack.push(code[1]);
            _pc ++;
        }
        
        private function OP_pushnull(code:Array):void
        {
            _stack.push(null);
            _pc ++;
        }
        
        private function OP_pushdefault(code:Array):void
        {
            _stack.push(ArgItem.DEFAULT);
            _pc ++;
        }
        
        private function OP_pop(code:Array):void
        {
            _stack.pop();
            _pc ++;
        }
        
        private function OP_dup(code:Array):void
        {
            var res:* = _stack.pop();
            _stack.push(res, res);
            _pc ++;
        }
        
        private function OP_swap(code:Array):void
        {
            var tmp:Array = [];
            tmp.push(_stack.pop())
            tmp.push(_stack.pop())
            _stack.push(tmp.shift())
            _stack.push(tmp.shift())
            _pc ++;
        }
        
        /**
        * [reverse n]
        * ... a1 a2 ... an ] --> ... an ... a2 a1]
        **///不创建_stack的副本
        private function OP_reverse(code:Array):void
        {
            var i:uint = code[1];
            var tmp:Array = [];
            while(i > 0)
            {
                tmp.push(_stack.pop());
                i --;
            }
            i = code[1]
            while(i > 0)
            {
                _stack.push(tmp.shift());
                i --;
            }
            _pc ++;
        }
        
        private function OP_iftrue(code:Array):void
        {
            var res:Boolean = _stack.pop();
            if(res)
            {
                _pc = code[1];
            }
            else
            {
                _pc ++;
            }
        }
        
        private function OP_iffalse(code:Array):void
        {
            var res:Boolean = _stack.pop();
            if(!res)
            {
                _pc = code[1];
            }
            else
            {
                _pc ++;
            }
        }
        
        private function OP_convert_b(code:Array):void
        {
            var res:* = _stack.pop();
            _stack.push(Boolean(res));
            _pc ++;
        }
        
        private function OP_add(code:Array):void
        {
            var p2:* = _stack.pop();
            var p1:* = _stack.pop();
            var res:* = p1 + p2;
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_sub(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Number = p1 - p2;
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_eq(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Boolean = (p1 == p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_ge(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Boolean = (p1 >= p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_gt(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Boolean = (p1 > p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_le(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Boolean = (p1 <= p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_lt(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Boolean = (p1 < p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_ne(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Boolean = (p1 != p2);
            _stack.push(res);
            _pc ++;
        }
        
        /**
        * [array, n]
        * ... a1, ...,an] --> ... [a1,...an] ]
        **/
        private function OP_array(code:Array):void
        {
            var i:uint = code[1];
            var res:Array = [];
            while(i > 0)
            {
                res.push(_stack.pop());
                i --;
            }
            res.reverse();
            _stack.push(res);
            _pc ++;
        }
        
        /**
        * [object, n]
        * ... name1, value1, ... ,namen, valuen] --> ... {name1:value1, ... namen:valuen}]
        **/
        private function OP_object(code:Array):void
        {
            var i:uint = code[1];
            var res:Object = {};
            while(i > 0)
            {
                var value:* = _stack.pop();  
                var name:String = _stack.pop();
                res[name] = value;
                i --;
            }
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_mult(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Number = p1 * p2;
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_div(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Number = p1 / p2;
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_mod(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Number = p1 % p2;
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_power(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Number = Math.pow(p1,p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_lshift(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Number = (p1 << p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_rshift(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Number = (p1 >> p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_urshift(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Number = (p1 >>> p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_bitor(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Number = (p1 | p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_bitxor(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Number = (p1 ^ p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_bitand(code:Array):void
        {
            var p2:Number = _stack.pop();
            var p1:Number = _stack.pop();
            var res:Number = (p1 & p2);
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_bitnot(code:Array):void
        {
            var p:Number = _stack.pop();
            var res:Number = ~ p;
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_not(code:Array):void
        {
            var p:Boolean = _stack.pop();
            var res:Boolean = ! p;
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_negate(code:Array):void
        {
            var p:Number = _stack.pop();
            var res:Number = - p;
            _stack.push(res);
            _pc ++;
        }
        
        private function OP_setLocalV(code:Array):void
        {
            _scope.currentObject[code[1]] = _stack[_stack.length - 1];
            _pc ++;
        }
        
        private function OP_setV(code:Array):void
        {
            _scope.setV(code[1], _stack[_stack.length - 1]);
            _pc ++;
        }
        
        private function OP_loadV(code:Array):void
        {
            var res:* = _scope.getV(code[1]);
            //对于立即函数进行一次计算
            if(res is NSUnitFunction)
            {
                res = (res as NSUnitFunction).apply(this, null);
            }
            _stack.push(res);
            _pc ++;
        }
        
        /**
        * [getProperty, p]
        * ...obj ] --> ...obj[p] ]
        **/
        private function OP_getProperty(code:Array):void
        {
            var obj:* = _stack.pop();
            var res:*;
            var proto:Object = null;
            var attri:String = code[1];
            
            //涉及原型的求值
            if(typeof obj == 'number' && NSNumber.getInstance().hasSlot(NSNumber.getInstance(), attri))
            {
                proto = NSNumber.getInstance();
            }
            else if(obj is Array && NSArray.getInstance().hasSlot(NSArray.getInstance(), attri))
            {
                proto = NSArray.getInstance();
            }
            else if(obj is String && NSString.getInstance().hasSlot(NSString.getInstance(), attri))
            {
                proto = NSString.getInstance();
            }
            else if(typeof obj == 'boolean' && NSBoolean.getInstance().hasSlot(NSBoolean.getInstance(), attri))
            {
                proto = NSBoolean.getInstance();
            }
            else if(NSObject.getInstance().hasSlot(NSObject.getInstance(), attri))//原型属性总是优先的
            {
                proto = NSObject.getInstance();
            }
            
            if(proto !== null)
            {
                //不必特意求值,__send方法包含的apply足可以对NSUnitFunction求值
                var old_self:* = this.scope.self;
                this.scope.self = obj;
                try
                {
                    res = proto.__send(obj, attri);
                }
                catch(e:Error)
                {
                    throw e;
                }
                finally
                {
                    this.scope.self = old_self;
                }
            }
            else
            {
                res = obj[code[1]];
            }
            _stack.push(res);
            _pc ++;
        }
        
        /**
        * [setProperty, p]
        * ... value, obj ] --> ... value], && obj[p] = value
        **/
        private function OP_setProperty(code:Array):void
        {
            var obj:* = _stack.pop();
            var value:* = _stack.pop();
            obj[code[1]] = value;
            _stack.push(value);
            _pc ++;
        }
        
        /**
        * [getIndex]
        * ... obj, [index1, index2,...] ] --> ... obj[index1] ]
        * ... obj, [index1, index2,...] ] --> ... obj(index1,index2,...) ] unless obj is NSLambdaFunction
        **/
        private function OP_getIndex(code:Array):void
        {
            var index:Array = _stack.pop();
            var obj:* = _stack.pop();
            if(obj is NSLambdaFunction)
            {
                var params:Object = {};
                index.forEach(function(item:*, i:uint, ...args):void
                {
                    params['@' + i] = item;
                });
                _stack.push(obj.call(params));
            }
            else if(obj is String)
            {
                _stack.push(NSString.getInstance().index(obj, index[0]));
            }
            else
            {//至于使用多个下标来索引一个一维数组的校验就暂时不做了,该行为以后再定义
                _stack.push(obj[index[0]]);
            }
            _pc ++;
        }
        
        /**
        * [setIndex]
        * ... obj, value, index ] --> ... value ], && obj[index] = value
        **/
        private function OP_setIndex(code:Array):void
        {
            var index:String = _stack.pop();
            var value:* = _stack.pop();
            var obj:* = _stack.pop();
            obj[index] = value;
            _stack.push(value);
            _pc ++;
        }
        
        /**
        * [exprs, from, to]
        * ... ] --> ... new Exprs(_code, from, to) ], && _pc = to + 1
        **/
        private function OP_exprs(code:Array):void
        {
            _stack.push(new Exprs(_codes, code[1], code[2], this));
            _pc = code[2] + 1;
        }
        
        /**
        * [eval_exprs]
        * ... exprs] --> ... exprs.eval(this)]
        **/
        private function OP_eval_exprs(code:Array):void
        {
            var exprs:Exprs = _stack.pop();
            var res:* = exprs.eval(this);
            _stack.push(res);
            _pc ++;
        }
        
        /**
        * [call, n]
        * ... arg1, arg2, ..., argn, func ] --> ...func.call(arg1,arg2,...,argn) ]
        * args : name : exprs | null : exprs
        **/
        private function OP_call(code:Array):void
        {
            var func:* = _stack.pop();
            var i:uint = code[1];
            var args:Array = [];
            while(i > 0)
            {
                var exprs:* = _stack.pop();//Exprs or ArgItem.DEFAULT
                var name:String = _stack.pop();
                args.push([name,exprs]);
                i --;
            }
            args.reverse();
            
            var res:*;
            var self:VirtualMathine = this;
            
            if(func is INSFunction)
            {
                res = (func as INSFunction).apply(this, args);    
            }
            else if(func is Function)
            {
                args = args.map(function(a:Array, ...args):*
                {
                    return (a[1] as Exprs).eval(self);
                });
                res = func.apply(func, args);
            }
            else
            {
                throw new Error("试图调用一个未知的函数.");
            }
            _stack.push(res);
            _pc ++;
        }
        
        /**
        * [callProperty, n]
        * ... arg1, arg2, ..., argn, obj, attri]
        **/
        private function OP_callProperty(code:Array):void
        {
            var attri:String = _stack.pop();
            var obj:* = _stack.pop();
            var i:uint = code[1];
            var args:Array = [];

            while(i > 0)
            {
                var exprs:* = _stack.pop();//Exprs or ArgItem.DEFAULT
                var name:String = _stack.pop();
                args.push([name,exprs]);
                i --;
            }
            args.reverse();
            
            var res:*;
            var proto:Object = null;
            
            if(typeof obj == 'number' && NSNumber.getInstance().hasSlot(NSNumber.getInstance(), attri))
            {
                proto = NSNumber.getInstance();
            }
            else if(obj is Array && NSArray.getInstance().hasSlot(NSArray.getInstance(), attri))
            {
                proto = NSArray.getInstance();
            }
            else if(obj is String && NSString.getInstance().hasSlot(NSString.getInstance(), attri))
            {
                proto = NSString.getInstance();
            }
            else if(typeof obj == 'boolean' && NSBoolean.getInstance().hasSlot(NSBoolean.getInstance(), attri))
            {
                proto = NSBoolean.getInstance();
            }
            else if(NSObject.getInstance().hasSlot(NSObject.getInstance(), attri))//原型属性总是优先的
            {
                proto = NSObject.getInstance();
            }
            
            if(proto !== null)
            {
                var func:* = proto[attri];
                if(func is INSFunction)
                {
                    var old_self:*;
                    old_self = this.scope.self;
                    this.scope.self = obj;
                    try
                    {
                        res = (func as INSFunction).apply(this, args);
                    }
                    catch(e:Error)
                    {
                        throw e;
                    }
                    finally
                    {
                        this.scope.self = old_self;//出错时self恢复
                    }
                }
                else
                {
                    res = proto.__send(obj, attri, args_filter(args)); 
                }
            }
            else
            {
                func = obj[attri];
                if(func is INSFunction)
                {
                    res = (func as INSFunction).apply(this, args);    
                }
                else if(func is Function)
                {
                    res = func.apply(obj, args_filter(args));
                }
                else
                {
                    throw new Error("试图调用一个未知的函数.");
                }
            }
            _stack.push(res);
            
            _pc ++;
        }
        
        private function args_filter(args:Array):Array
        {
            var self:VirtualMathine = this;
            return args.map(function(a:Array, ... any):*
            {
                return (a[1] as Exprs).eval(self);
            });
        }
        
        /**
        * [lambda]
        * ... exprs ] --> ... new NSLambdaFunction('lambda', function(paramms:Object):*{...}]
        **/
        private function OP_lambda(code:Array):void
        {
            var exprs:Exprs = _stack.pop();
            var lsc:IContext = _scope;
            var self:VirtualMathine = this;
            
            var res:NSLambdaFunction = new NSLambdaFunction('<lambda>', function(params:Object):*
            {
                var ctx:IContext = lsc.newContext(params);
                self.pushScope(ctx);
                
                var ret:* = exprs.eval(self);
                
                self.popScope();
                return ret;
            });
            
            _stack.push(res);
            _pc ++;
        }
        public function get scope():IContext
        {
            return _scope;
        }

    }
}