package org.flixel.plugin.leveluplabs;
import haxe.xml.Fast;
import org.flixel.FlxSprite;

/**
 * A group with vertical and horizontal scrolling if some elements are located outstide
 * @author Masadow
 */
class FlxScrollGroup extends FlxUI, implements IEventGetter
{
	public var horizontalScrollEnabled : Bool;
	public var verticalScrollEnabled : Bool;
	public var border : FlxBorder;
	private var _back:FlxSprite;

	public function new(back:FlxSprite,data:Fast=null,superIndex_:FlxUI=null) 
	{
		super(data, this, superIndex_);
		
		_back = back;
		add(_back);
		members.insert(0, members.pop());

	}

	/*
	 * IDestroyable impl
	 */
	override function destroy() : Void
	{
		super.destroy();
	}

		/***Event Handling***/
	
	override public function getEvent(id:String, sender:Dynamic, data:Dynamic):Void {
		//not yet implemented
	}
	
	override public function getRequest(id:String, sender:Dynamic, data:Dynamic):Dynamic {
		//not yet implemented
		return null;
	}	

}