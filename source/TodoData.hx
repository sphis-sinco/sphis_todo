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
	public var entry_names:Array<String> = [];

	@:default([])
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

		this.entry_names = json.entry_names;
		this.entry_values = json.entry_values;
	}

	public function toString():String
	{
		return 'TodoData(id:' + id + ', entry_names: ' + entry_names + ', entry_values: ' + entry_values + ')';
	}
}
