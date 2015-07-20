package extension;
import extension.parts.TitleBar;
import extension.parts.Button;
import jQuery.JQuery;
class View
{
	@:allow(extension) private static var instance(get, null):View;
	private static inline function get_instance():View
		return instance == null ? instance = new View(): instance;

	private var element:JQuery;
	public var runButton(default, null):Button;
	public var runNewLayerButton(default, null):Button;
	private function new()
	{
		element =  new JQuery("#pixel_outline_runner");

		//new TitleBar("title_option", element);

		runButton = new Button(element, "run_button");
		runNewLayerButton = new Button(element, "run_new_layer_button");
	}
	/*
	public function isCreatedNewLayer():Bool{
		return isChecked("new_layer_creation");
	}
	public function isDisplayedErrorAlert():Bool{
		return isChecked("error_alert_display");
	}
	private function isChecked(className:String):Bool{
		return new JQuery('.$className', element).is(":checked");
	}
	*/
}
