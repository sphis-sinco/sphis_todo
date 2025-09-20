package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public var data(default, set):TodoData = new TodoData('dummy');

	function set_data(value:TodoData):TodoData
	{
		if (listName != null)
			listName.text = value.id;

		if (listEntriesText != null)
		{
			updateListEntriesText();
		}

		return value;
	}

	public var listName:FlxText;

	public var listEntriesText:FlxTypedGroup<FlxText>;
	public var listEntriesCheckbox:FlxTypedGroup<Checkbox>;

	public var selected:Int = 0;

	public var camFollow:FlxObject = new FlxObject();

	override public function create()
	{
		super.create();
		listName = new FlxText();
		listName.scrollFactor.set(0, 0);
		listName.setPosition(16, 32);
		listName.size = 32;
		listName.text = data.id;
		add(listName);

		listEntriesText = new FlxTypedGroup<FlxText>();
		add(listEntriesText);

		listEntriesCheckbox = new FlxTypedGroup<Checkbox>();
		add(listEntriesCheckbox);

		updateListEntriesText();
		FlxG.camera.follow(camFollow, LOCKON, .45);
		camFollow.x = FlxG.width / 4;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (selected < 0)
			selected = 0;
		if (selected >= listEntriesText.members.length)
			selected = listEntriesText.members.length - 1;
		for (text in listEntriesText.members)
		{
			text.color = FlxColor.WHITE;
			if (selected == text.ID)
			{
				text.color = FlxColor.YELLOW;
				camFollow.y = text.y;
			}
		}
		if (FlxG.keys.justReleased.UP)
			selected--;
		if (FlxG.keys.justReleased.DOWN)
			selected++;
	}

	function updateListEntriesText()
	{
		for (text in listEntriesText.members)
		{
			listEntriesText.members.remove(text);
			text.destroy();
		}

		var i = 0;
		for (entry in data.entry_names)
		{
			var txt:FlxText = new FlxText(32, 32, 0, entry + '(' + data.entry_values[i] + ')', 16);
			txt.ID = i;
			txt.y = 32 + i * 128;
			listEntriesText.add(txt);

			var checkbox:Checkbox = new Checkbox(data.entry_values[i], txt.x, txt.y);
			checkbox.y = txt.y - (checkbox.height / 2);
			txt.x += checkbox.width + 32;
			listEntriesCheckbox.add(checkbox);

			i++;
		}
	}
}
