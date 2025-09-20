package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

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

	public var selected:Int = 0;

	override public function create()
	{
		super.create();
		listName = new FlxText();
		listName.scrollFactor.set(0, 0);
		listName.setPosition(32, 32);
		listName.size = 32;
		listName.text = data.id;
		add(listName);

		listEntriesText = new FlxTypedGroup<FlxText>();
		add(listEntriesText);
		updateListEntriesText();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
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
			var txt:FlxText = new FlxText(32, 32, 0, entry, 16);
			txt.ID = i;
			listEntriesText.add(txt);

			i++;
		}
	}
}
