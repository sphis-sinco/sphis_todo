package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Checkbox extends FlxSprite
{
	public var state(default, set):CheckboxStates = NA;

	function set_state(value:CheckboxStates):CheckboxStates
	{
		if (value == DONE)
			color = FlxColor.LIME;
		else if (value == WORKING)
			color = FlxColor.YELLOW;
		else if (value == NOT_STARTED)
			color = FlxColor.RED;
		else
		{
			if (value != NA)
				trace('Unimplemented state case: '+value.getName());
                        
			color = FlxColor.WHITE;
		}

		return value;
	}

	override public function new(State:CheckboxStates, ?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);

		state = State;

		loadGraphic('assets/ui/checkbox.png');
		updateHitbox();
	}
}

enum CheckboxStates
{
	NA;
	NOT_STARTED;
	WORKING;
	DONE;
}
