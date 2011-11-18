package org.lala.niwan.interpreter.adapters.elements
{
    import flash.display.Shape;
    import flash.display.Sprite;
    
    import org.lala.niwan.interpreter.adapters.interfaces.IShape;
    
    public class TheShape implements IShape
    {
        private var _shape:Shape;
        private var _stage:Sprite;
        private var _config:Object;
        
        public function TheShape(params:Object,ground:Sprite)
        {
            _shape = new Shape;
            _stage = ground;
            _config = params;
            init();
            _stage.addChild(_shape);
        }
        
        private function init():void
        {
            draw();
            x = _config['x']; 
            y = _config['y']; 
            rotation = _config['rotation']; 
            alpha = _config['alpha'];
            visible = _config['visible'];
        }
        
        private function draw():void
        {
            _shape.graphics.clear();
            
            _shape.graphics.beginFill(_config['color']);
            switch(_config['shape'])
            {
                case 'circle':
                    _shape.graphics.drawEllipse(0, 0, _config['width'], _config['height']);
                    break;
                default:
                    _shape.graphics.drawRect(0, 0, _config['width'], _config['height']);
                    break;
            }
            _shape.graphics.endFill();
        }
        
        public function get x():Number
        {
            return _shape.x;
        }
        
        public function get y():Number
        {
            return _shape.y;
        }
        
        public function get z():uint
        {
            return _config['z'];
        }
        
        public function get shape():String
        {
            return _config['shape'];
        }
        
        public function get width():Number
        {
            return _config['width'];
        }
        
        public function get height():Number
        {
            return _config['height'];
        }
        
        public function get color():uint
        {
            return _config['color'];
        }
        
        public function get visible():Boolean
        {
            return _shape.visible;
        }
        
        public function get pos():String
        {
            return _config['pos'];
        }
        
        public function get mask():Boolean
        {
            return _config['mask'];
        }
        
        public function get commentmask():Boolean
        {
            return _config['commentmask'];
        }
        
        public function get alpha():Number
        {
            return 100 - _shape.alpha * 100;
        }
        
        public function get rotation():Number
        {
            return _shape.rotation;
        }
        
        public function get mover():String
        {
            return _config['mover'];
        }
        
        public function set x(value:Number):void
        {
            _shape.x = value;
        }
        
        public function set y(value:Number):void
        {
            _shape.y = value;
        }
        
        public function set z(value:uint):void
        {
            _config['z'] = value;
        }
        
        public function set shape(value:String):void
        {
            _config['shape'] = value;
            draw();
        }
        
        public function set width(value:Number):void
        {
            _config['width'] = value;
            draw();
        }
        
        public function set height(value:Number):void
        {
            _config['height'] = value;
            draw();
        }
        
        public function set color(value:uint):void
        {
            _config['color'] = value;
            draw();
        }
        
        public function set visible(value:Boolean):void
        {
            _shape.visible = value;
        }
        
        public function set pos(value:String):void
        {
            _config['pos'] = value;
        }
        
        public function set mask(value:Boolean):void
        {
            _config['mask'] = value;
        }
        
        public function set commentmask(value:Boolean):void
        {
            _config['commentmask'] = value;
        }
        
        public function set alpha(value:Number):void
        {
            _shape.alpha = 1 - value/100;
        }
        
        public function set rotation(value:Number):void
        {
            _shape.rotation = value;
        }
        
        public function set mover(value:String):void
        {
            _config['mover'] = value;
        }
    }
}