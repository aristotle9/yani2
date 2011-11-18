package org.lala.niwan.interpreter.adapters.interfaces
{
    public interface IShape
    {
        function get x():Number;
        function get y():Number;
        
        function get z():uint;
        
        function get shape():String;
        
        function get width():Number;
        function get height():Number;
        
        function get color():uint;
        function get visible():Boolean;
        function get pos():String;
        function get mask():Boolean;
        function get commentmask():Boolean;
        
        function get alpha():Number;
        function get rotation():Number;
        function get mover():String;
        /*========*/
        function set x(value:Number):void;
        function set y(value:Number):void;
        
        function set z(value:uint):void;
        
        function set shape(value:String):void;
        
        function set width(value:Number):void;
        function set height(value:Number):void;
        
        function set color(value:uint):void;
        function set visible(value:Boolean):void;
        function set pos(value:String):void;
        function set mask(value:Boolean):void;
        function set commentmask(value:Boolean):void;
        
        function set alpha(value:Number):void;
        function set rotation(value:Number):void;
        function set mover(value:String):void;
    }
}