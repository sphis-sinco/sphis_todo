package;

import Checkbox.CheckboxStates;
import json2object.JsonParser;
import lime.utils.Assets;
#if sys
import sys.io.File;
#end

class TodoData
{
	@:default([])
	public var entries:Array<{name:String, value:CheckboxStates}> = [];

	@:default([])
	@:optional
	public var entry_names:Array<String> = [];

	@:default([])
	@:optional
	public var entry_values:Array<CheckboxStates> = [];

	@:jignored
	public var id:String = '';

	public function new(id:String)
	{
		var parser = new JsonParser<TodoData>();
		var path = 'assets/lists/' + id + '.json';
		var data = #if sys File.getContent(path) #else Assets.getText(path) #end;
		var json = parser.fromJson(data);

		if (json == null)
			throw 'Error parsing TODO list: ' + id;

		this.id = id;

		this.entries = json.entries;
		this.entry_names = json.entry_names;
		this.entry_values = json.entry_values;
		if (this.entries.length < this.entry_names.length)
		{
			var i = 0;
			for (name in this.entry_names)
			{
				this.entries.push({
					name: name ?? 'null_entry_' + i,
					value: this?.entry_values[i] ?? NA
				});

				trace('Moved entry_name: ' + this.entries[this.entries.length - 1] + ' to entries');

				i++;
			}
		}
		
	}

	public function toString():String
	{
		return 'TodoData(id:' + id + ', entries:' + entries + ')';
	}
}
