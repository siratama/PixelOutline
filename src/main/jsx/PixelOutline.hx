package jsx;

import psd.SolidColor;
import psd.Layer;
import psd.ArtLayer;
import psd.StrokeLocation;
import jsx.util.PrivateAPI;
import common.PixelOutlineInitialErrorEvent;
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
	/*
	private var documentHeight:Int;
	private var documentWidth:Int;
	*/

	public static function main()
	{
		#if normal
		PixelOutlineJSXRunner.execute(false);
		#elseif newlayer
		PixelOutlineJSXRunner.execute(true);
		#end
	}

	public function new()
	{
		application = app;
	}
	public function getInitialErrorEvent():String
	{
		var error =
			(application.documents.length == 0) ?
				PixelOutlineInitialError.UNOPENED_DOCUMENT:
			(application.activeDocument.activeLayer.typename == LayerTypeName.LAYER_SET) ?
				PixelOutlineInitialError.SELECTED_LAYER_SET:
			(!application.activeDocument.isSelectedSingleLayer()) ?
				PixelOutlineInitialError.UNSELECTED_SINGLE_LAYER:
			(application.activeDocument.activeLayer.allLocked) ?
				PixelOutlineInitialError.SELECTED_LOCKED_LAYER:
			(cast(application.activeDocument.activeLayer, ArtLayer).isBackgroundLayer) ?
				PixelOutlineInitialError.SELECTED_BACKGROUND_LAYER:
			(!application.activeDocument.activeLayer.hasPixel()) ?
				PixelOutlineInitialError.SELECTED_TRANSPARENT_LAYER:
				null;

		var event = (error == null) ? PixelOutlineInitialErrorEvent.NONE: PixelOutlineInitialErrorEvent.ERROR(error);
		return Serializer.run(event);
	}

	public function execute(serializedNewLayerCreation:String):Void
	{
		var isNewLayerCreation:Bool = Unserializer.run(serializedNewLayerCreation);
		activeDocument = application.activeDocument;

		var baseLayer = activeDocument.activeLayer;
		var newLayer = createNewLayer(baseLayer);

		var activeLayerDefaultVisible = baseLayer.visible;
		if(!activeLayerDefaultVisible) baseLayer.visible = true;

		PrivateAPI.selectShapeBorder(baseLayer);
		activeDocument.activeLayer = newLayer;

		var selection = activeDocument.selection;
		selection.invert();
		selection.contract(Std.string(BORDER_PIXEL_SIZE));
		selection.invert();
		selection.fill(application.foregroundColor);

		PrivateAPI.selectShapeBorder(baseLayer);
		activeDocument.activeLayer = newLayer;
		selection.clear();
		selection.deselect();

		if(!isNewLayerCreation){
			cast(newLayer, ArtLayer).merge();
		}

		if(!activeLayerDefaultVisible) baseLayer.visible = false;
	}

	private function createNewLayer(baseLayer:Layer):Layer
	{
		var newLayer = baseLayer.duplicate();
		newLayer.name = baseLayer.name + " outline";
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

	}
}

private class PixelOutlineJSXRunner
{
	public static function execute(isNewLayerCreation:Bool)
	{
		var pixelOutline = new PixelOutline();
		var errorEvent:PixelOutlineInitialErrorEvent = Unserializer.run(pixelOutline.getInitialErrorEvent());
		switch(errorEvent)
		{
			case PixelOutlineInitialErrorEvent.ERROR(error):
				js.Lib.alert(cast(error, String));

			case PixelOutlineInitialErrorEvent.NONE:
				var serializedToCreateNewLayer = Serializer.run(isNewLayerCreation);
				pixelOutline.execute(serializedToCreateNewLayer);
		}
	}
}
