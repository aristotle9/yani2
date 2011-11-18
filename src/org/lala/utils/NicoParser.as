package org.lala.utils 
{
	public class NicoParser
	{
		public static function parse(xml:XML):Array
		{
			var res:Array=[];
            
			var xmllist:XMLList = xml.descendants('chat');
            var len:uint = xmllist.length();
            var i:uint = 0;

            while(i < len)
			{
				var itm:*= xmllist[i];
                i ++;				
				if (itm.@deleted != 1)
				{
					var obj:Object =
					{
//						'anonymity':itm.@anonymity,
//						'date':Strings.date(new Date(int(itm.@date) * 1000)),
//						'thread':itm.@thread,
//						'user_id':itm.@user_id,
						'id':itm.@no,
						'stime':int(itm.@vpos)/100,
						'text':itm.toString(),//.replace(/(\/n|\\n)/g, "\n"),
						'border':false
					};
					obj['mode']  = getMode(itm.@mail);
					obj['color'] = getColor(itm.@mail);
					obj['size']  = getSize(itm.@mail);
					res.push(obj);
				}
			}
			return res;
		}
		public static function getMode(mail:String):int
		{
			var mode:int = 1;
			
			var modestr:String = '';
			var arr:Array = mail.match(/(shita|ue|naka)/);
			
			if (arr)
			{
				modestr = arr[1];
			}
			
			switch(modestr)
			{
				case "shita":
                    mode = 0x000004; break;
				case "ue":
                    mode = 0x000005; break;
            }
			return mode;
		}
		public static function getSize(mail:String):int
		{
			var size:int = 16;
			
			var sizestr:String = '';
			var arr:Array = mail.match(/(big|medium|small)/);
			
			if (arr)
			{
				sizestr = arr[1];
			}

			switch(sizestr)
			{
                case "small":
                    size = 0x00000D; break;
                case "big":
                    size = 0x000013; break;
			}
				
			return size;
		}
		public static function getColor(mail:String):int
		{
			var clr:int = 0xffffff;
			
			var clrstr:String = '';
			var arr:Array =	mail.match(/(white|red|pink|orange|yellow|green|cyan|blue|purple|niconicowhite|white2|truered|red2|passionorange|orange2|madyellow|yellow2|elementalgreen|green2|marineblue|blue2|nobleviolet|purple2|black|\#[0-9a-f]{6})/i);
			
			if (arr)
			{
				clrstr = arr[1];
			}

			switch(clrstr)
			{
                case "red":
                    clr = 0xFF0000; break;
                case "pink":
                    clr = 0xFF8080; break;
                case "orange":
                    clr = 0xFFCC00; break;
                case "yellow":
                    clr = 0xFFFF00; break;
                case "green":
                    clr = 0x00FF00; break;
                case "cyan":
                    clr = 0x00FFFF; break;
                case "blue":
                    clr = 0x0000FF; break;
                case "purple":
                    clr = 0xC000FF; break;
                case "niconicowhite":
                    clr = 0xCCCC99; break;
                case "white2":
                    clr = 0xCCCC99; break;
                case "truered":
                    clr = 0xCC0033; break;
                case "red2":
                    clr = 0xCC0033; break;
                case "passionorange":
                    clr = 0xFF6600; break;
                case "orange2":
                    clr = 0xFF6600; break;
                case "madyellow":
                    clr = 0x999900; break;
                case "yellow2":
                    clr = 0x999900; break;
                case "elementalgreen":
                    clr = 0x00CC66; break;
                case "green2":
                    clr = 0x00CC66; break;
                case "marineblue":
                    clr = 0x33FFFC; break;
                case "blue2":
                    clr = 0x33FFFC; break;
                case "nobleviolet":
                    clr = 0x6633CC; break;
                case "purple2":
                    clr = 0x6633CC; break;
                case "black":
                    clr = 0x000000; break;
                default:
                {
					if (clrstr.match(/^\#[0-9a-f]{6}/i))
					{
						clr=Number(clrstr.replace(/^\#/, "0x"));
					}
                    break;
                }
			}
			
			return clr;
		}
		
	}

}
