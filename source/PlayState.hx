package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class PlayState extends FlxState
{
	public var lists = ['dummy'];

	public var data:TodoData = new TodoData('dummy');

	public var listName:FlxText;

	public var listEntriesText:FlxTypedGroup<FlxText>;
	public var listEntriesCheckbox:FlxTypedGroup<Checkbox>;

	public var selected:Int = 0;

	public var camFollow:FlxObject = new FlxObject();

	public var fileIcon:FileIcon;

	override public function create()
	{
		super.create();

		#if sys
		lists = [];
		for (list in FileSystem.readDirectory('assets/lists/'))
		{
			if (StringTools.endsWith(list, '.json') && !FileSystem.isDirectory('assets/lists/' + list))
			{
				lists.push(StringTools.replace(list, '.json', ''));
				trace('New list: ' + lists[lists.length - 1]);
			}
		}
		if (lists == [] || lists == null)
		{
			File.saveContent('assets/lists/dummy.json',
				'{"entry_names": ["Entry Name 1","Entry Name 2","Entry Name 3","Entry Name 4"],"entry_values": ["NA", "NOT_STARTED", "WORKING", "DONE"]}');
			lists.push('dummy');
		}
		data = new TodoData(lists[0]);
		#end

		listName = new FlxText();
		listName.scrollFactor.set(0, 0);
		listName.setPosition(16, 32);
		listName.size = 32;
		listName.text = data.id;
		add(listName);

		fileIcon = new FileIcon(NEW, 16, FlxG.height - 256);
		fileIcon.scrollFactor.set();
		fileIcon.alpha = 0;
		add(fileIcon);

		listEntriesText = new FlxTypedGroup<FlxText>();
		add(listEntriesText);

		listEntriesCheckbox = new FlxTypedGroup<Checkbox>();
		add(listEntriesCheckbox);

		updateListEntriesText(true);
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
		if (FlxG.keys.justReleased.R)
		{
			data = new TodoData(data.id);
			updateListEntriesText(true);
		}
		if (FlxG.keys.justReleased.ENTER)
		{
			switch (data.entry_values[selected])
			{
				case NOT_STARTED:
					data.entry_values[selected] = WORKING;
				case WORKING:
					data.entry_values[selected] = DONE;
				case DONE:
					data.entry_values[selected] = NA;
				default:
					data.entry_values[selected] = NOT_STARTED;
			}

			trace('Entry ' + (selected + 1) + ' status update to: ' + data.entry_values[selected]);
			updateListEntriesText();
		}
		for (text in listEntriesText.members)
		{
			text.color = FlxColor.WHITE;
			if (selected == text.ID)
			{
				text.color = FlxColor.YELLOW;
				camFollow.y = text.y;
			}
		}
		if (FlxG.keys.justReleased.DELETE)
		{
			var sel = lists.indexOf(data.id);
			#if sys
			if (lists.length > 1)
			{
				if (sel < 1)
					sel++;
				else
					sel--;

				if (sel >= lists.length)
					sel--;
			}
			else
			{
				File.saveContent('assets/lists/dummy.json',
					'{"entry_names": ["Entry Name 1","Entry Name 2","Entry Name 3","Entry Name 4"],"entry_values": ["NA", "NOT_STARTED", "WORKING", "DONE"]}');
				lists.push('dummy');
				sel = 0;
			}

			FileSystem.deleteFile('assets/lists/' + data.id + '.json');
			lists.remove(data.id);
			trace('Deleted list: ' + data.id);

			data = new TodoData(lists[sel]);
			fileIcon.append = DELETE;
			fileIcon.alpha = 1;
			FlxTween.cancelTweensOf(fileIcon);
			FlxTween.tween(fileIcon, {alpha: 0}, 1);

			updateListEntriesText(true);
			#end
		}
		if (FlxG.keys.justReleased.UP)
			selected--;
		if (FlxG.keys.justReleased.DOWN)
			selected++;
		if (FlxG.keys.justReleased.E)
			FlxG.camera.zoom -= .25;
		if (FlxG.keys.justReleased.Q)
			FlxG.camera.zoom += .25;

		if (FlxG.camera.zoom < .5)
			FlxG.camera.zoom = .5;
		if (FlxG.camera.zoom > 1)
			FlxG.camera.zoom = 1;
		if (FlxG.keys.anyJustReleased([LEFT, RIGHT]))
		{
			var sel = lists.indexOf(data.id);
			var prevData = new TodoData(data.id);

			if (lists.length > 1)
			{
				if (FlxG.keys.justReleased.LEFT)
					sel--;
				if (FlxG.keys.justReleased.RIGHT)
					sel++;

				if (sel < 0)
					sel = 0;
				if (sel >= lists.length)
					sel = lists.length - 1;

				trace(lists[sel]);
			}

			data = new TodoData(lists[sel]);
			trace(data.id);
			if (data.id != prevData.id)
			{
				fileIcon.append = SWAP;
				fileIcon.alpha = 1;
				FlxTween.cancelTweensOf(fileIcon);
				FlxTween.tween(fileIcon, {alpha: 0}, 1);

				updateListEntriesText(true);
			}
		}
	}

	function updateListEntriesText(is_new:Bool = false)
	{
		if (is_new)
			trace('Loading list: ' + data.id);
		else
			trace('Reloading list: ' + data.id);

		if (listEntriesText.members.length > 0)
		{
			for (text in listEntriesText.members)
			{
				listEntriesText.members.remove(text);
				text.destroy();
			}
			for (checkbox in listEntriesCheckbox.members)
			{
				listEntriesCheckbox.members.remove(checkbox);
				checkbox.destroy();
			}

			listEntriesText.clear();
			listEntriesCheckbox.clear();
		}

		if (is_new)
			trace(data.entry_names.length + ' entries');

		var i = 0;
		for (entry in data.entry_names)
		{
			var txt:FlxText = new FlxText(32, 32, 0, entry + ' (' + data.entry_values[i] + ')', 16);
			txt.ID = i;
			txt.y = 32 + i * 128;
			listEntriesText.add(txt);

			var checkbox:Checkbox = new Checkbox(data.entry_values[i], txt.x, txt.y);
			checkbox.y = txt.y - (checkbox.height / 2);
			txt.x += checkbox.width + 32;
			listEntriesCheckbox.add(checkbox);

			if (is_new)
				trace('Added entry #' + (i + 1) + '. State: ' + data.entry_values[i]);

			i++;
		}
		#if sys
		File.saveContent('assets/lists/' + data.id + '.json', Json.stringify(data));
		#end
		if (listName != null)
		{
			listName.text = data.id;

			if (data.entry_names.length < 1)
				listName.text += ' (EMPTY)';
		}
	}
}
