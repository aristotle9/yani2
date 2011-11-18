package org.lala.niwan.parser
{
    
    public class Lexer
    {
        protected var _transTable:Array;
        protected var _finalTable:Object;
        protected var _inputTable:Array;
        protected var _initialTable:Object;
        protected const DEADSTATE:uint = uint.MAX_VALUE;
        
        protected var _start:uint;
        protected var _oldStart:uint;
        protected var _tokenName:String;
        protected var _yytext:*;
        protected var _yy:Object;
        protected var _ended:Boolean;
        protected var _initialInput:Number;
        protected var _initialState:String;
        
        protected var _line:uint;
        protected var _col:uint;
        protected var _advanced:Boolean;
        
        protected var _source:String;
        
    private function escapeText(str:String):String
    {
        return str.replace(/\\(.)/g, function(...args):String
        {
            switch(args[1])
            {
                case 't':
                    return '\t';
                case 'n':
                    return '\n';
                case 'r':
                    return '\r';
                case 'f':
                    return '\f';
                default:
                    return args[1];
            }
            return args[1];
        });
    }
;

        public function Lexer()
        {
            _transTable = 
[[false,[4294967295,1],[[0,46,0],[47,47,1]]],[false,[4294967295,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2],[[0,0,0],[1,1,1],[2,2,2],[3,3,3],[4,4,4],[5,5,5],[6,6,6],[7,7,7],[8,8,8],[9,9,9],[10,10,10],[11,11,11],[12,12,12],[13,13,13],[14,14,14],[15,15,15],[16,16,16],[17,17,17],[18,18,18],[19,19,19],[20,20,20],[21,21,21],[22,22,22],[23,23,23],[24,24,24],[25,25,25],[26,27,26],[28,28,27],[29,29,28],[30,39,29],[40,40,30],[41,41,31],[42,42,32],[43,43,33],[44,44,34],[45,46,35],[47,47,0]]],[false,[4294967295,2],[[0,44,0],[45,46,1],[47,47,0]]],[false,[4294967295,38,37,4],[[0,9,0],[10,10,1],[11,39,0],[40,40,2],[41,43,0],[44,44,3],[45,47,0]]],[false,[4,39,4294967295],[[0,44,0],[45,45,1],[46,46,0],[47,47,2]]],[false,[4294967295,8,40],[[0,23,0],[24,28,1],[29,29,0],[30,30,2],[31,39,1],[40,41,0],[42,42,1],[43,47,0]]],[false,[6,42,41,4294967295],[[0,18,0],[19,19,1],[20,40,0],[41,41,2],[42,44,0],[45,45,3],[46,46,0],[47,47,3]]],[false,[4294967295,44,43],[[0,9,0],[10,10,1],[11,39,0],[40,40,2],[41,47,0]]],[false,[4294967295,8],[[0,23,0],[24,28,1],[29,29,0],[30,39,1],[40,41,0],[42,42,1],[43,47,0]]],[false,[4294967295,45],[[0,23,0],[24,24,1],[25,25,0],[26,27,1],[28,47,0]]],[false,[4294967295,8,46],[[0,23,0],[24,28,1],[29,29,0],[30,30,1],[31,31,2],[32,39,1],[40,41,0],[42,42,1],[43,47,0]]],[false,[4294967295,11,47,48],[[0,23,0],[24,24,1],[25,25,0],[26,27,1],[28,28,0],[29,29,2],[30,37,0],[38,39,3],[40,47,0]]],[false,[4294967295,8,49],[[0,23,0],[24,28,1],[29,29,0],[30,31,1],[32,32,2],[33,39,1],[40,41,0],[42,42,1],[43,47,0]]],[false,[4294967295,51,52,47,50,48],[[0,23,0],[24,24,1],[25,25,0],[26,26,1],[27,27,2],[28,28,0],[29,29,3],[30,36,0],[37,37,4],[38,39,5],[40,47,0]]],[false,[4294967295,54,53],[[0,9,0],[10,10,1],[11,22,0],[23,23,2],[24,47,0]]],[false,[4294967295,56,55],[[0,9,0],[10,10,1],[11,21,0],[22,22,2],[23,47,0]]],[true],[false,[4294967295,58,57],[[0,9,0],[10,10,1],[11,19,0],[20,20,2],[21,47,0]]],[true],[false,[19,41,59,4294967295],[[0,17,0],[18,18,1],[19,19,2],[20,44,0],[45,45,3],[46,46,0],[47,47,3]]],[true],[false,[4294967295,60],[[0,9,0],[10,10,1],[11,47,0]]],[true],[true],[false,[4294967295,61],[[0,9,0],[10,10,1],[11,47,0]]],[false,[4294967295,62],[[0,9,0],[10,10,1],[11,47,0]]],[false,[4294967295,63],[[0,9,0],[10,10,1],[11,47,0]]],[false,[4294967295,64],[[0,9,0],[10,10,1],[11,47,0]]],[false,[4294967295,67,66,65],[[0,7,0],[8,8,1],[9,9,2],[10,10,3],[11,47,0]]],[false,[4294967295,69,68],[[0,7,0],[8,8,1],[9,9,0],[10,10,2],[11,47,0]]],[false,[4294967295,71,70],[[0,6,0],[7,7,1],[8,9,0],[10,10,2],[11,47,0]]],[true],[true],[true],[true],[true],[true],[false,[37,72,4294967295],[[0,39,0],[40,40,1],[41,44,0],[45,45,2],[46,46,0],[47,47,2]]],[true],[false,[4294967295,39],[[0,44,0],[45,45,1],[46,47,0]]],[false,[4294967295,8,73],[[0,23,0],[24,28,1],[29,29,0],[30,31,1],[32,32,2],[33,39,1],[40,41,0],[42,42,1],[43,47,0]]],[true],[false,[6,4294967295],[[0,44,0],[45,45,1],[46,46,0],[47,47,1]]],[true],[true],[false,[4294967295,45,48],[[0,23,0],[24,24,1],[25,25,0],[26,27,1],[28,37,0],[38,39,2],[40,47,0]]],[false,[4294967295,8,74],[[0,23,0],[24,28,1],[29,29,0],[30,32,1],[33,33,2],[34,39,1],[40,41,0],[42,42,1],[43,47,0]]],[false,[4294967295,45],[[0,23,0],[24,24,1],[25,25,0],[26,27,1],[28,47,0]]],[false,[4294967295,76,75],[[0,21,0],[22,23,1],[24,24,2],[25,25,0],[26,27,2],[28,47,0]]],[false,[4294967295,8,77],[[0,23,0],[24,28,1],[29,29,0],[30,32,1],[33,33,2],[34,39,1],[40,41,0],[42,42,1],[43,47,0]]],[false,[4294967295,78],[[0,23,0],[24,24,1],[25,25,0],[26,28,1],[29,30,0],[31,31,1],[32,35,0],[36,36,1],[37,37,0],[38,39,1],[40,47,0]]],[false,[4294967295,51,52,47,48],[[0,23,0],[24,24,1],[25,25,0],[26,26,1],[27,27,2],[28,28,0],[29,29,3],[30,37,0],[38,39,4],[40,47,0]]],[false,[4294967295,52,47,48],[[0,23,0],[24,24,1],[25,25,0],[26,27,1],[28,28,0],[29,29,2],[30,37,0],[38,39,3],[40,47,0]]],[true],[true],[true],[true],[false,[4294967295,79],[[0,9,0],[10,10,1],[11,47,0]]],[true],[false,[19,4294967295],[[0,44,0],[45,45,1],[46,46,0],[47,47,1]]],[true],[true],[true],[true],[true],[true],[false,[4294967295,80],[[0,9,0],[10,10,1],[11,47,0]]],[true],[true],[false,[4294967295,82,81],[[0,7,0],[8,8,1],[9,9,0],[10,10,2],[11,47,0]]],[true],[false,[4294967295,83],[[0,9,0],[10,10,1],[11,47,0]]],[false,[37,72,84,4294967295],[[0,39,0],[40,40,1],[41,43,0],[44,44,2],[45,45,3],[46,46,0],[47,47,3]]],[false,[4294967295,8,85],[[0,23,0],[24,28,1],[29,29,0],[30,37,1],[38,38,2],[39,39,1],[40,41,0],[42,42,1],[43,47,0]]],[false,[4294967295,8,86],[[0,23,0],[24,28,1],[29,29,0],[30,33,1],[34,34,2],[35,39,1],[40,41,0],[42,42,1],[43,47,0]]],[false,[4294967295,75],[[0,23,0],[24,24,1],[25,25,0],[26,27,1],[28,47,0]]],[false,[4294967295,75],[[0,23,0],[24,24,1],[25,25,0],[26,27,1],[28,47,0]]],[false,[4294967295,8,87],[[0,23,0],[24,28,1],[29,29,0],[30,32,1],[33,33,2],[34,39,1],[40,41,0],[42,42,1],[43,47,0]]],[false,[4294967295,78],[[0,23,0],[24,24,1],[25,25,0],[26,28,1],[29,30,0],[31,31,1],[32,35,0],[36,36,1],[37,37,0],[38,39,1],[40,47,0]]],[true],[true],[true],[false,[4294967295,88],[[0,9,0],[10,10,1],[11,47,0]]],[true],[true],[false,[4294967295,8],[[0,23,0],[24,28,1],[29,29,0],[30,39,1],[40,41,0],[42,42,1],[43,47,0]]],[false,[4294967295,8,89],[[0,23,0],[24,28,1],[29,29,0],[30,37,1],[38,38,2],[39,39,1],[40,41,0],[42,42,1],[43,47,0]]],[false,[4294967295,8],[[0,23,0],[24,28,1],[29,29,0],[30,39,1],[40,41,0],[42,42,1],[43,47,0]]],[true],[false,[4294967295,8],[[0,23,0],[24,28,1],[29,29,0],[30,39,1],[40,41,0],[42,42,1],[43,47,0]]]]
;_finalTable = 
{2:0,3:51,4:1,5:11,7:50,8:11,9:60,10:11,11:6,12:11,13:6,14:48,15:49,16:13,17:35,18:15,20:14,21:52,22:58,23:61,24:36,25:54,26:16,27:17,28:42,29:43,30:37,31:63,32:53,33:32,34:62,35:64,36:59,38:22,39:1,40:11,41:12,43:55,44:21,45:8,46:11,49:11,51:7,52:9,53:56,54:19,55:57,56:20,57:33,58:29,60:23,61:31,62:39,63:18,64:38,65:40,66:45,67:44,68:41,69:46,70:30,71:34,73:11,74:11,75:9,77:11,78:10,79:25,80:27,81:26,82:47,83:24,84:2,85:3,86:11,87:5,88:28,89:4}
;_inputTable = 
[[0,8,0],[9,9,46],[10,10,45],[11,11,0],[12,12,46],[13,13,45],[14,31,0],[32,32,46],[33,33,12],[34,34,41],[35,35,43],[36,36,35],[37,37,16],[38,38,7],[39,39,18],[40,40,15],[41,41,1],[42,42,40],[43,43,23],[44,44,21],[45,45,22],[46,46,29],[47,47,44],[48,48,24],[49,55,26],[56,57,27],[58,58,11],[59,59,17],[60,60,9],[61,61,10],[62,62,8],[63,63,4],[64,64,35],[65,68,36],[69,69,39],[70,70,36],[71,87,35],[88,88,37],[89,90,35],[91,91,14],[92,92,19],[93,93,3],[94,94,13],[95,95,35],[96,96,0],[97,97,31],[98,100,36],[101,101,38],[102,102,28],[103,107,35],[108,108,33],[109,109,35],[110,110,25],[111,113,35],[114,114,30],[115,115,34],[116,116,42],[117,117,32],[118,119,35],[120,120,37],[121,122,35],[123,123,6],[124,124,20],[125,125,2],[126,126,5],[127,65535,0]]
;_initialTable = 
{"INITIAL":1}
;
        }
        
        public function yyrestart(src:String=null):void
        {
            if(src != null)
            {
                _source = src;
            }
            _ended = false;
            _start = 0;
            _oldStart = 0;
            _line = 1;
            _col = 0;
            _advanced = true;
            _tokenName = null;
            _yy = {};
            initialState = "INITIAL";
            ;

        }
        
        public function set source(src:String):void
        {
            _source = src;
            yyrestart();
        }
        
        public function get token():String
        {
            if(_advanced)
            {
                _tokenName = next();
                _advanced = false;
            }
            return _tokenName;
        }
        
        public function advance():void
        {
            _advanced = true;
        }
        
        public function get startIdx():uint
        {
            return _oldStart;
        }
        
        public function get endIdx():uint
        {
            return _start;
        }
        
        public function get position():Array
        {
            return [_line,_col];
        }
        
        public function get positionInfo():String
        {
            return token + '@row:' + position.join('col:');   
        }
        
        public function get yytext():*
        {
            return _yytext;
        }
        
        public function get yyleng():uint
        {
            return endIdx - startIdx;
        }
        
        public function set yytext(value:*):void
        {
            _yytext = value;
        }
        
        public function get yy():Object
        {
            return _yy;
        }

        public function get tokenName():String
        {
            return _tokenName;
        }
        
        protected function next():String
        {
            var _findex:*;
            var _nextState:*;
            var _char:Number;
            var _begin:uint;
            var _next:uint;
            var _ochar:uint;
            var _curState:uint;
            var _lastFinalState:uint;
            var _lastFinalPosition:uint;
            
            while(true)
            {
                _findex = null;
                _nextState = null;
                _char = 0;
                _begin = _start;
                _next = _start;
                _ochar = uint.MAX_VALUE;
                _lastFinalState = DEADSTATE;
                _lastFinalPosition = _start;
                _curState = _transTable[0][1][_initialInput];
                while(true)
                {
                    _char = _source.charCodeAt(_next);
                    /** 计算行,列位置 **/
                    if(_ochar != uint.MAX_VALUE)
                    {
                        if(_char == 0x0d)//\r
                        {
                            _col = 0;
                            _line ++;
                        }
                        else if(_char == 0x0a)//\n
                        {
                            if(_ochar != 0x0d)// != \r
                            {
                                _col = 0;
                                _line ++;
                            }
                        }
                        else
                        {
                            _col ++;
                        }
                    }
                    _ochar = _char;
                    /** 计算行,列位置--结束 **/
                    _nextState = trans(_curState, _char);
                    if(_nextState == DEADSTATE)
                    {
                        if(_begin == _lastFinalPosition)
                        {
                            if(_start == _source.length)
                            {
                                if(_ended == false)
                                {
                                    _ended = true;
                                    return "<$>";
                                }
                                else
                                {
                                    throw new Error("已经到达末尾.");
                                }                    
                            }
                            throw new Error("意外的字符,line:" + position.join(",col:") + 'of ' + _source.substr(_begin,20));
                        }
                        else
                        {
                            _findex = _finalTable[_lastFinalState];
                            _start = _lastFinalPosition;
                            _oldStart = _begin;
                            _yytext = _source.substring(startIdx, endIdx);
                            switch(_findex)
{
case 0x3:
    yytext = true; return 'bool';
    break;
case 0x4:
    yytext = false; return 'bool';
    break;
case 0x5:
    yytext = null; return 'string';
    break;
case 0x6:
    yytext = parseInt(yytext); return 'number';
    break;
case 0x7:
    yytext = parseInt(yytext, 8); return 'number';
    break;
case 0x8:
    yytext = parseFloat(yytext); return 'number';
    break;
case 0x9:
    yytext = parseFloat(yytext); return 'number';
    break;
case 0xA:
    yytext = parseInt(yytext, 16); return 'number';
    break;
case 0xB:
    return 'id';
    break;
case 0xC:
    yytext = yytext.substr(1, yyleng - 2); yytext = escapeText(yytext); return 'string';
    break;
case 0xD:
    return ',';
    break;
case 0xE:
    return ';';
    break;
case 0xF:
    return '\\';
    break;
case 0x10:
    return ':';
    break;
case 0x11:
    return '=';
    break;
case 0x12:
    return ':=';
    break;
case 0x13:
    return '+=';
    break;
case 0x14:
    return '-=';
    break;
case 0x15:
    return '*=';
    break;
case 0x16:
    return '/=';
    break;
case 0x17:
    return '%=';
    break;
case 0x18:
    return '&&=';
    break;
case 0x19:
    return '||=';
    break;
case 0x1A:
    return '>>=';
    break;
case 0x1B:
    return '<<=';
    break;
case 0x1C:
    return '>>>=';
    break;
case 0x1D:
    return '|=';
    break;
case 0x1E:
    return '&=';
    break;
case 0x1F:
    return '^=';
    break;
case 0x20:
    return '?';
    break;
case 0x21:
    return '||';
    break;
case 0x22:
    return '&&';
    break;
case 0x23:
    return '|';
    break;
case 0x24:
    return '^';
    break;
case 0x25:
    return '&';
    break;
case 0x26:
    return '==';
    break;
case 0x27:
    return '!=';
    break;
case 0x28:
    return '<=';
    break;
case 0x29:
    return '>=';
    break;
case 0x2A:
    return '<';
    break;
case 0x2B:
    return '>';
    break;
case 0x2C:
    return '<>';
    break;
case 0x2D:
    return '<<';
    break;
case 0x2E:
    return '>>';
    break;
case 0x2F:
    return '>>>';
    break;
case 0x30:
    return '+';
    break;
case 0x31:
    return '-';
    break;
case 0x32:
    return '*';
    break;
case 0x33:
    return '/';
    break;
case 0x34:
    return '%';
    break;
case 0x35:
    return '~';
    break;
case 0x36:
    return '!';
    break;
case 0x37:
    return '**';
    break;
case 0x38:
    return '++';
    break;
case 0x39:
    return '--';
    break;
case 0x3A:
    return '(';
    break;
case 0x3B:
    return ')';
    break;
case 0x3C:
    return '.';
    break;
case 0x3D:
    return '[';
    break;
case 0x3E:
    return ']';
    break;
case 0x3F:
    return '{';
    break;
case 0x40:
    return '}';
    break;
}
                            break;
                        }
                    }
                    else
                    {
                        _findex = _finalTable[_nextState];
                        if(_findex != null)
                        {
                            _lastFinalState = _nextState;
                            _lastFinalPosition = _next + 1;
                        }
                        _next += 1;
                        _curState = _nextState;
                    }
                }
            }
            return "";//这里的值会影响返回值!!
        }
        protected function trans(curState:uint,char:Number):uint
        {
            if(isNaN(char))
                return DEADSTATE;
            if(char < _inputTable[0][0] || char > _inputTable[_inputTable.length - 1][1])
                throw new Error("输入超出有效范围,line:" + position.join(",col:"));
            if(_transTable[curState][0] == true)
                return DEADSTATE;

            var ipt:int = find(char,_inputTable);
            var ipt2:int = find(ipt, _transTable[curState][2]);
            return _transTable[curState][1][ipt2];
        }
        
        protected function find(code:uint,seg:Array):uint
        {
            var min:uint;
            var max:uint;
            var mid:uint;
            min = 0;
            max = seg.length - 1;
            while(true)
            {
                mid = (min + max) >>> 1;
                if(seg[mid][0] <= code && seg[mid][1] >= code)
                {
                    return seg[mid][2];
                }
                else if(seg[mid][0] > code)
                {
                    max = mid - 1;
                }
                else
                {
                    min = mid + 1;
                }
            }
            return 0;
        }
        
        protected function begin(state:String=null):void
        {
            if(state == null)
            {
                initialState = "INITIAL";
                return;
            }
            initialState = state;
        }
        
        protected function get initialState():String
        {
            return _initialState;
        }

        protected function set initialState(value:String):void
        {
            if(_initialTable[value] === undefined)
            {
                throw new Error("未定义的起始状态:" + value);
            }
            _initialState = value;
            _initialInput = _initialTable[value];
        }
    }
}