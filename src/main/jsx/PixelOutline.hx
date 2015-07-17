package jsx;

import psd.Layer;
import psd.ArtLayer;
import psd.StrokeLocation;
import jsx.util.PrivateAPI;
import common.PixelOutlineEvent;
import psd.LayerTypeName;
import haxe.Serializer;
import haxe.Unserializer;
import psd.Application;
import psd.Document;
import psd.Lib.app;

using jsx.util.ErrorChecker;

@:keep
@:native("PixelOutline")
class PixelOutline
{
	private var application:Application;
	private var activeDocument:Document;
	private static inline var BORDER_PIXEL_SIZE = 1;

	public static function main()
	{
		PixelOutlineTest.execute();
	}
	public function new()
	{
		application = app;
	}
	public function getInitialErrorEvent():String
	{
		var activeLayer = application.activeDocument.activeLayer;
		var event =
			(application.documents.length == 0) ?
				PixelOutlineInitialErrorEvent.ERROR("Open document."):
			(activeLayer.typename == LayerTypeName.LAYER_SET) ?
				PixelOutlineInitialErrorEvent.SELECTED_LAYER_SET:
			(!application.activeDocument.isSelectedSingleLayer()) ?
				PixelOutlineInitialErrorEvent.UNSELECTED_SINGLE_LAYER:
			(activeLayer.allLocked) ?
				PixelOutlineInitialErrorEvent.SELECTED_LOCKED_LAYER:
			(cast(activeLayer, ArtLayer).isBackgroundLayer) ?
				PixelOutlineInitialErrorEvent.SELECTED_BACKGROUND_LAYER:
				PixelOutlineInitialErrorEvent.NONE;

		return Serializer.run(event);
	}

	public function execute(serializedNewLayerCreation:String):Void
	{
		var newLayerCreation:Bool = Unserializer.run(serializedNewLayerCreation);
		//newLayerCreation = true;

		activeDocument = application.activeDocument;
		var baseLayer = activeDocument.activeLayer;
		var activeLayerDefaultVisible = baseLayer.visible;

		if(!activeLayerDefaultVisible) baseLayer.visible = true;

		var newLayer = (newLayerCreation) ? createNewLayer(baseLayer) : null;

		PrivateAPI.selectShapeBorder(baseLayer.name);

		if(newLayerCreation){
			activeDocument.activeLayer = newLayer;
		}

		strokeOutline();

		if(!activeLayerDefaultVisible) baseLayer.visible = false;
	}
	private function createNewLayer(baseLayer:Layer):Layer
	{
		var newLayer = baseLayer.duplicate();
		activeDocument.activeLayer = newLayer;

		var selection = activeDocument.selection;
		selection.selectAll();
		selection.clear();
		selection.deselect();

		activeDocument.activeLayer = baseLayer;

		return newLayer;
	}
	private function strokeOutline()
	{
		var selection = activeDocument.selection;
		selection.invert();
		selection.contract(Std.string(BORDER_PIXEL_SIZE));
		selection.invert();
		selection.stroke(application.foregroundColor, BORDER_PIXEL_SIZE, StrokeLocation.INSIDE);
		selection.deselect();
	}
}

private class PixelOutlineTest
{
	public static function execute()
	{
		var pixelOutline = new PixelOutline();
		var errorEvent:PixelOutlineInitialErrorEvent = Unserializer.run(pixelOutline.getInitialErrorEvent());
		switch(errorEvent)
		{
			case PixelOutlineInitialErrorEvent.ERROR(message):
				js.Lib.alert(message);
				return;
			case PixelOutlineInitialErrorEvent.SELECTED_LAYER_SET:
				js.Lib.alert("selected layer set");
				return;
			case PixelOutlineInitialErrorEvent.UNSELECTED_SINGLE_LAYER:
				js.Lib.alert("unselected single layer");
				return;
			case PixelOutlineInitialErrorEvent.SELECTED_LOCKED_LAYER:
				js.Lib.alert("selected locked layer");
				return;
			case PixelOutlineInitialErrorEvent.SELECTED_BACKGROUND_LAYER:
				js.Lib.alert("selected background layer");
				return;
			case PixelOutlineInitialErrorEvent.NONE: "";
		}

		var newLayerCreation = false;
		var serializedToCreateNewLayer = Serializer.run(newLayerCreation);
		pixelOutline.execute(serializedToCreateNewLayer);
		/*
		var event:PixelOutlineEvent = Unserializer.run(result);
		js.Lib.alert(event);
		*/
	}
}
