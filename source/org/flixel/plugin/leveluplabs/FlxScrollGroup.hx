package org.flixel.plugin.leveluplabs;
import haxe.xml.Fast;
import nme.geom.Rectangle;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;

enum ScrollAlign
{
	Vertical;
	Horizontal;
}

enum ScrollState
{
	Normal;
	Hilight;
	Pressed;
}

class FlxScrollBar implements IDestroyable
{
	private var scrollgroup:FlxScrollGroup;
	private var align:ScrollAlign;
	
	private var normal:Flx9SliceSprite;
	private var hilight:Flx9SliceSprite;
	private var pressed:Flx9SliceSprite;
	
	private var active:Flx9SliceSprite;
	
	private var state:ScrollState;
	
	private var lastMouse:FlxPoint;

	public function new(align:ScrollAlign, scrollgroup:FlxScrollGroup, x:Float, y:Float, graphic:Dynamic, hgraphic:Dynamic, pgraphic:Dynamic, rc:Rectangle)
	{
		state = Normal;
		
		this.normal = new Flx9SliceSprite(x, y, graphic, rc);
		this.hilight = new Flx9SliceSprite(x, y, hgraphic, rc);
		this.hilight.visible = false;
		this.pressed = new Flx9SliceSprite(x, y, pgraphic, rc);
		this.pressed.visible = false;
		this.active = normal;

		this.align = align;
		this.scrollgroup = scrollgroup;
		
		this.scrollgroup.add(normal);
		this.scrollgroup.add(hilight);
		this.scrollgroup.add(pressed);

		
		lastMouse = new FlxPoint();
		FlxG.mouse.copyTo(lastMouse);
	}
	
	/*
	 * IDestroyable impl
	 */
	public function destroy() : Void
	{
		scrollgroup = null;
		normal.destroy();
		hilight.destroy();
		pressed.destroy();
	}

	public function update(mouse:FlxPoint, buttonDown:Bool)
	{
		var onScroll:Bool = false;
		var scroll:FlxPoint = active.getScreenXY();
		if (mouse.x > scroll.x && mouse.x < scroll.x + active.width
			&& mouse.y > scroll.y && mouse.y < scroll.y + active.height)
			onScroll = true;

		/*
		 * Change state
		 */
		var tmpstate = state;
		switch (state)
		{
			case Normal:
				if (onScroll)
					state = buttonDown ? Pressed : Hilight;
			case Hilight:
				if (!onScroll)
					state = Normal;
				else if (buttonDown)
					state = Pressed;
			case Pressed:
				if (!buttonDown && onScroll)
					state = Hilight;
				else if (!buttonDown)
					state = Normal;
		}
		
		/*
		 * Apply new state
		 */
		if (tmpstate != state)
		{
			active.visible = false;
			//Make sure positions are up to date
			normal.x = active.x;
			normal.y = active.y;
			hilight.x = active.x;
			hilight.y = active.y;
			switch (state)
			{
				case Normal: active = normal; active.visible = true;
				case Hilight: active = hilight; active.visible = true;
				case Pressed: active = pressed; active.visible = true;					
			}
		}

		/*
		 * Move component
		 */
		if (state == Pressed)
		{
			var offset:Float = align == Vertical ? lastMouse.y - mouse.y : lastMouse.x - mouse.x;
			if (offset != 0 && align == Vertical)
				active.y -= offset;
			else if (offset != 0 && align == Horizontal)
				active.x -= offset;
			//Out of box => Replace component
			if (active.y < scrollgroup.y) active.y = scrollgroup.y;
			if (active.x < scrollgroup.x) active.x = scrollgroup.x;
			if (active.x > scrollgroup.x + scrollgroup.contentRect.x - active.width) active.x = scrollgroup.x + scrollgroup.contentRect.x - active.width;
			if (active.y > scrollgroup.y + scrollgroup.contentRect.y - active.height) active.y = scrollgroup.y + scrollgroup.contentRect.y - active.height;
		}

		lastMouse.copyFrom(mouse);
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

	private var verticalBar:FlxScrollBar;
	private var horizontalBar:FlxScrollBar;
	
	public var sb_thickness:Int = 15;
		
	public function new(graphics:Dynamic,contentRect:Rectangle,back:FlxSprite,data:Fast=null,superIndex_:FlxUI=null)
	{
		super(data, this, superIndex_);
		
		_back = back;
		add(_back);
		members.unshift(members.pop());
		
		this.contentRect = contentRect;
		
		//width and height are changed ? Save into contentRect as x & y
		this.contentRect.x = width;
		this.contentRect.y = height;
		
		if (graphics.normal != "" && graphics.hilight != "")
		{
			verticalBar = new FlxScrollBar(Vertical, this, width - sb_thickness, 0, graphics.normal, graphics.hilight, graphics.pressed, new Rectangle(0, 0, sb_thickness, (height * height) / contentRect.height));
		}
		if (graphics.normal != "" && graphics.hilight != "")
		{
			horizontalBar = new FlxScrollBar(Horizontal, this, 0, height - sb_thickness, graphics.normal, graphics.hilight, graphics.pressed, new Rectangle(0, 0, (width * width) / contentRect.width, sb_thickness));
		}
		
		
	}

	override public function update():Void 
	{
		super.update();
		var mouse:FlxPoint = FlxG.mouse.getScreenPosition();
		verticalBar.update(mouse, FlxG.mouse.pressed());
		horizontalBar.update(mouse, FlxG.mouse.pressed());
	}
	
	/*
	 * IDestroyable impl
	 */
	override function destroy() : Void
	{
		super.destroy();
		_back.destroy();
		verticalBar.destroy();
		horizontalBar.destroy();
		contentRect = null;
	}

}