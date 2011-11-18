package org.lala.niwan.interpreter.runtime
{
    import org.lala.niwan.interpreter.interfaces.IContext;
    
    public class Context implements IContext
    {
        protected var _parent:IContext;
        protected var _object:Object;
        protected var _self:Object;
        
        public function Context(obj:Object=null, parent:IContext=null)
        {
            _object = obj == null ? {} : obj;
            _parent = parent;
            _self = _object;
            if(obj.hasOwnProperty('self'))
                _self = obj.self;
        }
        
        public function get parent():IContext
        {
            return _parent;
        }
        
        public function get currentObject():Object
        {
            return _object;
        }
        
        public function get self():Object
        {
            return _self;
        }
        
        public function find(id:String):Boolean
        {
            return this._object.hasOwnProperty(id);
        }
        
        public function setV(id:String, value:*):void
        {
            if(id == 'self')
            {
                throw new Error('self无法赋值.');
            }
            var ctx:IContext = this;
            while(ctx.find(id) == false)
            {
                ctx = ctx.parent;
            }
            ctx.currentObject[id] = value;
        }
        
        public function getV(id:String):*
        {
            if(id == 'self')
            {
                return this.self;
            }
            var ctx:IContext = this;
            while(ctx.find(id) == false)
            {
                ctx = ctx.parent;
            }
            return ctx.currentObject[id];    
        }
        
        public function newContext(obj:Object):IContext
        {
            return new Context(obj, this);
        }

        public function set self(value:Object):void
        {
            _self = value;
        }

    }
}