package org.lala.niwan.compiler
{
    import org.lala.niwan.ast.Node;
    import org.lala.niwan.types.TypeClass;

    public class CodeGenerator
    {
        private var _codes:Array;
        public function CodeGenerator()
        {
            _codes = [];
        }
        
        protected function put(...args):uint
        {
            _codes.push(args);
            return _codes.length - 1;
        }
        
        protected function get pos():uint
        {
            return _codes.length - 1;
        }
        
        protected function set_code(label:uint,...args):void
        {
            _codes[label] = args;
        }
        
        public function reset():void
        {
            _codes = [];
        }
        
        public function gen_code(tree:Node):void
        {
            if(this.hasOwnProperty(['GEN_' + tree.name]))
            {
                this['GEN_' + tree.name](tree);       
            }
            else
            {
                return;
            }
        }
        
        public function GEN_program(tree:Node):void
        {
            gen_code(tree.nodes[0]);
            put('eval_exprs');//对栈中的Exprs求值
        }

        public function GEN_exprs(tree:Node):void
        {
            var lb:uint = put('exprs');
            var i:uint = 1;
            gen_code(tree.nodes[0]);
            while(i < tree.nodes.length)
            {
                put('pop');//前面的表达式的值抛弃
                gen_code(tree.nodes[i]);
                i++;
            }
            set_code(lb,'exprs',lb + 1, pos);//创建一个Exprs,从p1到p2,压入栈
        }
        
        public function GEN_lambda(tree:Node):void
        {
            gen_code(tree.nodes[0])
            put('lambda');
        }
        
        public function GEN_additive(tree:Node):void
        {
            gen_code(tree.nodes[0])
            gen_code(tree.nodes[1])
            tree.attri == '+' ? put('add') : put('sub');
        }
        
        public function GEN_multiplicative(tree:Node):void
        {
            gen_code(tree.nodes[0])
            gen_code(tree.nodes[1])
            switch(tree.attri)
            {
                case '*':
                    put('mult')
                    break;
                case '/':
                    put('div')
                    break;
                case '%':
                    put('mod')
                    break;
            }
        }
        
        public function GEN_power(tree:Node):void
        {
            gen_code(tree.nodes[0])
            gen_code(tree.nodes[1])
            put('power')
        }
        
        public function GEN_bitshift(tree:Node):void
        {
            gen_code(tree.nodes[0])
            gen_code(tree.nodes[1])
            switch(tree.attri)
            {
                case '<<':
                    put('lshift')
                    break;
                case '>>':
                    put('rshift')
                    break;
                case '>>>':
                    put('urshift')
                    break;
            }
        }
        
        public function GEN_prefix_unary(tree:Node):void
        {
            gen_code(tree.nodes[0])
            switch(tree.attri)
            {
                case '+f':
                    break;
                case '-f':
                    put('negate')
                    break;
                case '!f':
                    put('not')
                    break;
                case '~f':
                    put('bitnot')
                    break;
            }
        }
        
        public function GEN_bitwise(tree:Node):void
        {
            gen_code(tree.nodes[0])
            gen_code(tree.nodes[1])
            switch(tree.attri)
            {
                case '|':
                    put('bitor')
                    break;
                case '^':
                    put('bitxor')
                    break;
                case '&':
                    put('bitand')
                    break;
            }
        }
        //一定要考虑逻辑短路
        //a && b
        public function GEN_logical(tree:Node):void
        {
            gen_code(tree.nodes[0])//a
            put('convert_b')//a
            put('dup')// a a
            var lb:uint = put('label');//a a
            put('pop')
            gen_code(tree.nodes[1])
            put('convert_b')
            switch(tree.attri)
            {
                case '||':
                    set_code(lb, 'iftrue', pos + 1);
                    break;
                case '&&':
                    set_code(lb, 'iffalse', pos + 1);
                    break;
            }
        }
        
        public function GEN_relational(tree:Node):void
        {
            gen_code(tree.nodes[0])
            gen_code(tree.nodes[1])
            switch(tree.attri)
            {
                case '==':
                    put('eq')
                    break;
                case '>=':
                    put('ge')
                    break;
                case '>':
                    put('gt')
                    break;
                case '<=':
                    put('le')
                    break;
                case '<':
                    put('lt')
                    break;
                case '!=':
                case '<>':
                    put('ne')
                    break;
            }
        }
        
        public function GEN_index(tree:Node):void
        {
            if(tree.type == TypeClass.LambdaType)
            {
                //没有符号表,根本推断不出来
                gen_code(tree.nodes[1])
                gen_code(tree.nodes[0])
                put('index_call');
            }
            else
            {
                gen_code(tree.nodes[0])
                gen_code(tree.nodes[1])
                put('getIndex');
            }
        }
        
        public function GEN_dot(tree:Node):void
        {
            gen_code(tree.nodes[0])
            put('getProperty', tree.attri);
        }
        
        public function GEN_unary_assignment(tree:Node):void
        {
            var target:Node = tree.nodes[0];
            switch(target.name)
            {
                case 'id':
                    switch(tree.attri)
                    {
                        case 'f++':
                        case 'f--':
                            put('loadV', target.attri);
                            put('dup')
                            put('push', 1)
                            tree.attri == 'f++' ? put('add') : put('sub'); 
                            put('setV', target.attri)
                            put('pop')
                            break;
                        case '++f':
                        case '--f':// ++a
                            put('loadV', target.attri);//v
                            put('push', 1)//v 1
                            tree.attri == '++f' ? put('add') : put('sub'); //v+1 
                            put('setV', target.attri)//v+1
                            break;
                    }
                    break;
                
                case 'dot':
                    switch(tree.attri)
                    {
                        case 'f++':
                        case 'f--':
                            //a.b ++
                            gen_code(target.nodes[0]);//a
                            put('dup');//aa
                            put('getProperty', target.attri);//a a.b
                            put('dup');//a v v
                            put('push', 1);//a v v 1
                            tree.attri == 'f++' ? put('add') : put('sub');//a v v+1
                            put('swap');//a v + 1 v
                            put('reverse', 3);//v v+1 a
                            put('setProperty', target.attri);//v v+1
                            put('pop');//v
                            break;
                        case '++f':
                        case '--f':
                            //++ a.b
                            gen_code(target.nodes[0]);//a
                            put('dup');//aa
                            put('getProperty', target.attri);//a v
                            put('push', 1);//a v 1
                            tree.attri == '++f' ? put('add') : put('sub');//a v+1
                            put('swap');//v+1 a
                            put('setProperty', target.attri);//v+1
                            break;
                    }
                    break;
                
                case 'index':
                    switch(tree.attri)
                    {
                        case 'f++':
                        case 'f--':
                            //a[b] ++;
                            gen_code(target.nodes[1]);//b
                            put('dup');//b b
                            gen_code(target.nodes[0]);//b b a
                            put('dup');//b b a a
                            put('reverse', 3);//b a a b
                            put('getIndex');//b a a[b]
                            put('dup');//b a a[b] a[b]
                            put('push', 1);//b a a[b] a[b] 1
                            tree.attri == 'f++' ? put('add') : put('sub');//b a a[b] (a[b] + 1)
                            put('reverse', 3);//b w v a
                            put('swap');//b w a v
                            put('reverse', 4);//v a w b
                            put('setIndex');//v w
                            put('pop');//v
                            break;
                        
                        case '++f':
                        case '--f':
                            //++ a[b]
                            gen_code(target.nodes[1]);//b
                            put('dup');//b b
                            gen_code(target.nodes[0]);//b b a
                            put('dup');//b b a a
                            put('reverse', 3);//b a a b
                            put('getIndex');//b a a[b]
                            put('push', 1);//b a a[b] 1
                            tree.attri == '++f' ? put('add') : put('sub');//b a w
                            put('swap');//b w a
                            put('reverse', 3);//a w b
                            put('setIndex');//w
                            break;
                    }
                    break;
            }
        }
        public function GEN_assignment(tree:Node):void
        {
            var left:Node = tree.nodes[0];
            var right:Node = tree.nodes[1];
            if(tree.attri == ':=')
            {
                if(left.name == 'id')
                {
                    gen_code(right)
                    put('setLocalV', left.attri);
                }
                else
                {
                    throw new Error("定义表达式(:=)左边必须是一个id.");
                }
            }
            else if(tree.attri == '=')
            {
                if(left.name == 'dot')
                {
                    gen_code(right)
                    gen_code(left.nodes[0])
                    put('setProperty', left.attri);
                }
                else if(left.name == 'index')
                {
                    gen_code(left.nodes[0])
                    gen_code(right)
                    gen_code(left.nodes[1])
                    put('setIndex');
                }
                else if(left.name == 'id')
                {
                    gen_code(right)
                    put('setV', left.attri);
                }
                else
                {
                    throw new Error("非法赋值.");
                }
            }
            else
            {
                switch(left.name)
                {
                    case 'id':
                        gen_code(left)
                        gen_code(right)
                        switch(tree.attri)
                        {
                            case '+=':
                                put('add');
                                break;
                            case '-=':
                                put('sub');
                                break;
                            case '*=':
                                put('mult');
                                break;
                            case '/=':
                                put('div');
                                break;
                            case '%=':
                                put('mod');
                                break;
                            case '<<=':
                                put('lshift');
                                break;
                            case '>>=':
                                put('rshift');
                                break;
                            case '>>>=':
                                put('urshift');
                                break;
                            case '|=':
                                put('bitor');
                                break;
                            case '^=':
                                put('bitxor');
                                break;
                            case '&=':
                                put('bitand');
                                break;
                        }
                        put('setV', left.attri);
                        break;
                    
                    case 'dot'://a.b += c
                        gen_code(left.nodes[0]);//a
                        put('dup');//aa
                        put('getProperty', left.attri);//a a.b
                        gen_code(right);//a a.b c
                        switch(tree.attri)
                        {
                            case '+=':
                                put('add');
                                break;
                            case '-=':
                                put('sub');
                                break;
                            case '*=':
                                put('mult');
                                break;
                            case '/=':
                                put('div');
                                break;
                            case '%=':
                                put('mod');
                                break;
                            case '<<=':
                                put('lshift');
                                break;
                            case '>>=':
                                put('rshift');
                                break;
                            case '>>>=':
                                put('urshift');
                                break;
                            case '|=':
                                put('bitor');
                                break;
                            case '^=':
                                put('bitxor');
                                break;
                            case '&=':
                                put('bitand');
                                break;
                        }//a v
                        put('swap');//v a
                        put('setProperty', left.attri);//a.b = v
                        break;
                      
                    case 'index':
                        //a[b] += c
                        gen_code(left.nodes[1]); //b
                        put('dup')//bb
                        gen_code(left.nodes[0]);//bba
                        put('dup')//bbaa
                        put('reverse',3);//baab
                        put('getIndex')//ba(a[b])
                        gen_code(right);//ba(a[b])c
                        switch(tree.attri)
                        {
                            case '+=':
                                put('add');
                                break;
                            case '-=':
                                put('sub');
                                break;
                            case '*=':
                                put('mult');
                                break;
                            case '/=':
                                put('div');
                                break;
                            case '%=':
                                put('mod');
                                break;
                            case '<<=':
                                put('lshift');
                                break;
                            case '>>=':
                                put('rshift');
                                break;
                            case '>>>=':
                                put('urshift');
                                break;
                            case '|=':
                                put('bitor');
                                break;
                            case '^=':
                                put('bitxor');
                                break;
                            case '&=':
                                put('bitand');
                                break;
                        }
                        //bav
                        put('swap');//bva
                        put('reverse',3);//avb
                        put('setIndex');
                        break;
                }
            }
        }
        
        public function GEN_call(tree:Node):void//E ( Args )
        {//分callProperty callIndex 普通call可以区别一些对原型方法的调用
            var left:Node = tree.nodes[0];
            var args:Node = tree.nodes[1];
            switch(left.name)
            {
                case 'dot':
                    gen_code(args);
                    gen_code(left.nodes[0]);
                    put('push', left.attri);
                    put('callProperty', args.attri.length);
                    break;
                case 'index':
                    gen_code(args);
                    gen_code(left.nodes[0]);
                    gen_code(left.nodes[1]);
                    put('callProperty', args.attri.length);
                    break;
                default:
                    gen_code(args)
                    gen_code(left)
                    put('call', args.attri.length);
                    break;
            }
        }
        
        public function GEN_args(tree:Node):void
        {
            var i:uint = 0;
            while(i < tree.attri.length)
            {
                if(tree.attri[i].length == 2)//有名字的参数
                {
                    put('push', tree.attri[i][0])
                    gen_code(tree.attri[i][1])
                }
                else if(tree.attri[i].length == 1)//无名参数
                {
                    put('pushnull')
                    gen_code(tree.attri[i][0])
                }
                else//略过参数
                {
                    put('pushdefault');
                    put('pushdefault');
                }
                i ++;
            }
        }
        
        public function GEN_array(tree:Node):void
        {
            gen_code(tree.attri)
            put('array', tree.attri.attri.length);
        }
        
        public function GEN_array_list(tree:Node):void
        {
            var i:uint = 0;
            while(i < tree.attri.length)
            {
                gen_code(tree.attri[i])
                i ++;
            }
        }
        
        public function GEN_object(tree:Node):void
        {
            gen_code(tree.attri)
            put('object', tree.attri.attri.length);
        }
        
        public function GEN_object_list(tree:Node):void
        {
            var i:uint = 0;
            while(i < tree.attri.length)
            {
                put('push', tree.attri[i].name)
                gen_code(tree.attri[i].value)
                i ++;
            }
        }
        
        public function GEN_bool(tree:Node):void
        {
            put('push', tree.attri);
        }
        
        public function GEN_string(tree:Node):void
        {
            put('push', tree.attri);
        }
        
        public function GEN_number(tree:Node):void
        {
            put('push', tree.attri);
        }
        
        public function GEN_id(tree:Node):void
        {
            put('loadV', tree.attri);
        }

        public function get codes():Array
        {
            return _codes;
        }

    }
}