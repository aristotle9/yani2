package org.lala.niwan.interpreter.adapters
{
    import flash.display.Sprite;
    
    import org.lala.niwan.interpreter.adapters.elements.TheShape;
    import org.lala.niwan.interpreter.adapters.interfaces.IShape;
    import org.lala.niwan.interpreter.runtime.NSNormalFunction;
    
    public class TheDrawShapeFunction extends NSNormalFunction
    {
        
        private var _stage:Sprite;
        
        public function TheDrawShapeFunction(ground:Sprite)
        {
            _stage = ground;
            super("drawShape", createShape);
            //default values//order sensible
            this.pushArgs(['x', 0]);
            this.pushArgs(['y', 0]);
            this.pushArgs(['z', 0]);
            
            this.pushArgs(['shape', 'circle']);
            
            this.pushArgs(['width', 30]);
            this.pushArgs(['height', 30]);
            
            this.pushArgs(['color', 0xff0000]);
            this.pushArgs(['visible', true]);
            this.pushArgs(['pos', 'naka']);
            this.pushArgs(['mask', false]);
            this.pushArgs(['commentmask', false]);
            
            this.pushArgs(['alpha', 0]);
            this.pushArgs(['rotation', 0]);
            this.pushArgs(['mover', ""]);
        }
        
        private function createShape(params:Object):IShape
        {
            return new TheShape(params, _stage);
        }
    }
}