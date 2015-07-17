package extension;

import common.PixelOutlineEvent;
import common.ClassName;
import common.JsxEvent;
import haxe.Unserializer;
import haxe.Serializer;

enum PixelOutlineRunnerEvent
{
	INITIAL_ERROR(error:PixelOutlineInitialErrorEvent);
	SUCCESS;
	NONE;
}

class PixelOutlineRunner
{
	private var mainFunction:Void->Void;
	private var csInterface:AbstractCSInterface;
	private var jsxEvent:JsxEvent;
	private var isCreatedNewLayer:Bool;
	private static inline var INSTANCE_NAME = "pixelOutline";
	
	private var event:PixelOutlineRunnerEvent;

	public function getEvent():PixelOutlineRunnerEvent
	{
		var n = event;
		event = PixelOutlineRunnerEvent.NONE;
		return n;
	}

	public function new()
	{
		csInterface = AbstractCSInterface.create();
	}
	public function run()
	{
		mainFunction();
	}

	public function call(isCreatedNewLayer:Bool)
	{
		this.isCreatedNewLayer = isCreatedNewLayer;
		event = PixelOutlineRunnerEvent.NONE;

		jsxEvent = JsxEvent.NONE;
		csInterface.evalScript('var $INSTANCE_NAME = new ${ClassName.PIXEL_OUTLINE}();');
		csInterface.evalScript('$INSTANCE_NAME.getInitialErrorEvent();', function(result){
			jsxEvent = JsxEvent.GOTTEN(result);
		});
		mainFunction = observeToRecieveInitialErrorEvent;
	}
	private function observeToRecieveInitialErrorEvent()
	{
		switch(recieveJsxEvent())
		{
			case JsxEvent.NONE: return;
			case JsxEvent.GOTTEN(serializedEvent):
				var initialErrorEvent:PixelOutlineInitialErrorEvent = Unserializer.run(serializedEvent);
				switch(initialErrorEvent)
				{
					case PixelOutlineInitialErrorEvent.NONE:
						execute();
					case _:
						destroy(PixelOutlineRunnerEvent.INITIAL_ERROR(initialErrorEvent));
				}
		}
	}
	private function execute()
	{
		var data = Serializer.run(isCreatedNewLayer);
		csInterface.evalScript('$INSTANCE_NAME.execute("$data");');
		destroy(PixelOutlineRunnerEvent.SUCCESS);
	}
	private function recieveJsxEvent():JsxEvent
	{
		var n = jsxEvent;
		jsxEvent = JsxEvent.NONE;
		return n;
	}
	private function destroy(event:PixelOutlineRunnerEvent)
	{
		this.event = event;
		mainFunction = finish;
	}
	private function finish(){}
}
