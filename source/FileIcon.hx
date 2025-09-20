package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class FileIcon extends FlxSprite
{
	public var append(default, set):FileIconAppends = NEW;

	function set_append(value:FileIconAppends):FileIconAppends
	{
		loadGraphic('assets/ui/File'+value);
		scale.set(.5, .5);
		updateHitbox();

		return value;
	}

	override public function new(Append:FileIconAppends, ?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);

		append = Append;
	}
}

enum abstract FileIconAppends(String)
{
	var NEW = 'New';
	var DELETE = 'Delete';
	var SWAP = 'Swap';
}
