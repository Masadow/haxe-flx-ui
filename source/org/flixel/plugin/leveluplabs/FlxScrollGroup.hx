package org.flixel.plugin.leveluplabs;
import haxe.xml.Fast;
import nme.geom.Rectangle;
import org.flixel.FlxSprite;

class FlxScrollBar extends Flx9SliceSprite, implements IEventGetter
{
	private var scrollgroup:FlxScrollGroup;
	
	public function new(scrollgroup:FlxScrollGroup, x:Float, y:Float, graphic:Dynamic, rc:Rectangle)
	{
		super(x, y, graphic, rc);
		this.scrollgroup = scrollgroup;
		scrollgroup.add(this);
	}
	
	/*
	 * IDestroyable impl
	 */
	override function destroy() : Void
	{
		super.destroy();
		scrollgroup = null;
	}

		/***Event Handling***/
	
	public function getEvent(id:String, sender:Dynamic, data:Dynamic):Void {
		//not yet implemented
	}
	
	public function getRequest(id:String, sender:Dynamic, data:Dynamic):Dynamic {
		//not yet implemented
		return null;
	}	
	
}

/**
 * A group with vertical and horizontal scrolling if some elements are located outstide
 * @author Masadow
 */
class FlxScrollGroup extends FlxUI, implements IEventGetter
{
	public var horizontalScrollEnabled : Bool = true;
	public var verticalScrollEnabled : Bool = true;
	public var contentRect : Rectangle;
	private var _back:FlxSprite;

	private var verticalBar:FlxSprite;
	private var horizontalBar:FlxSprite;
	
	public function new(graphics:Dynamic,contentRect:Rectangle,back:FlxSprite,data:Fast=null,superIndex_:FlxUI=null)
	{
		super(data, this, superIndex_);
		
		_back = back;
		add(_back);
		members.unshift(members.pop());
		
		this.contentRect = contentRect;

		if (graphics.normal != "")
			verticalBar = new FlxScrollBar(this, width - 20, 0, graphics.normal, new Rectangle(0,0, 20, (height * height) / contentRect.height));
		if (graphics.normal != "")
			horizontalBar = new FlxScrollBar(this, 0, height - 20, graphics.normal, new Rectangle(0,0, (width * width) / contentRect.width, 20));
	}

	override public function update():Void 
	{
		super.update();		
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