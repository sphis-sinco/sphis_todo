package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class FileIcon extends FlxSprite
{
	public var state(default, set):FileIconAppends = NEW;

	function set_state(value:FileIconAppends):FileIconAppends
	{
		loadGraphic('assets/ui/File'+value);

		return value;
	}

	override public function new(State:FileIconAppends, ?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);

		state = State;

		scale.set(.5, .5);
		updateHitbox();
	}
}

enum abstract FileIconAppends(String)
{
	var NEW = 'New';
	var DELETE = 'Delete';
	var SWAP = 'Swap';
}
