package org.lala.niwan.interpreter.runtime
{
    import org.lala.niwan.interpreter.VirtualMathine;

    public class Exprs
    {
        private var _from:uint;
        private var _to:uint;
        private var _codes:Array;
        public function Exprs(codes:Array, from:uint, to:uint)
        {
            _codes = codes;
            _from = from;
            _to = to;
        }

        public function get from():uint
        {
            return _from;
        }
        
        public function get to():uint
        {
            return _to;
        }
        
        public function eval(vm:VirtualMathine):*
        {
            return vm.run_range(_codes, _from, _to);
        }

        public function get codes():Array
        {
            return _codes;
        }

    }
}