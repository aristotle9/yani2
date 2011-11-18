package org.lala.niwan.interpreter
{
    import org.lala.niwan.ast.Node;
    import org.lala.niwan.compiler.CodeGenerator;
    import org.lala.niwan.interpreter.interfaces.IContext;
    import org.lala.niwan.interpreter.runtime.GlobalContext;
    import org.lala.niwan.parser.Lexer;
    import org.lala.niwan.parser.Parser;

    /**
    * 求值工具
    * <pre>
    * 可以分别对一个字符串代码,字节码求值
    * 全局使用一个虚拟机,一个scope
    * </pre>
    ***/
    public class Evaluator
    {
        protected var _vm:VirtualMathine;
        protected var _cg:CodeGenerator;
        
        protected var _lexer:Lexer;
        protected var _parser:Parser;
        
        /** 初始化基础部件 **/
        public function Evaluator(ctx:IContext=null)
        {
            if(ctx == null)
                ctx = GlobalContext.getInstance();
            
            _vm = new VirtualMathine(ctx);
            _cg = new CodeGenerator;
            
            _lexer = new Lexer;
            _parser = new Parser;
            
            //执行一些特殊的初始化
            init();
        }
        /**
        * 附加的初始化操作
        ***/
        public function init():void
        {
        }
        
        /**
        * 对一个字符串求值,可以是String,或者一个xml element
        * <pre>
        * xml对象使用toString方法转化为脚本字符串
        * </pre>
        * @param src 将要运行的脚本,可以是字符串或者是一个xml
        * @return 运行的结果
        ***/
        public function evalSource(src:Object):*
        {
            var codes:Array = this.genCodes(src.toString());            
            return this.evalCodes(codes);
        }
        /**
        * 生成代码
        * @param src 源代码文本
        * @return 生成的代码序列
        */
        public function genCodes(src:String):Array
        {
            _lexer.source = src.toString();
            var tree:Node = _parser.parse(_lexer);
            
            _cg.reset();
            _cg.gen_code(tree);
            return _cg.codes;
        }
        /**
        * 对一个代码序列求值
        * @param codes 代码序列
        * @return 运行结果
        ***/
        public function evalCodes(codes:Array):*
        {
            _vm.codes = codes;
            return _vm.run();
        }
        /**
        * 上下文
        * @return 上下文对象
        **/
        public function get globalObject():Object
        {
            return _vm.scope.currentObject;
        }
        
    }
}