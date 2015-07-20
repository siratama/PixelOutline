package jsx.util;
import psd.Layer;
import psd.Document;
class ErrorChecker
{
	public static function isSelectedSingleLayer(activeDocument:Document):Bool
	{
		var selectedSingleLayer = true;
		var selection = activeDocument.selection;
		try{
			selection.deselect();
			var x = 0;
			var y = 0;
			selection.select([[x, y], [x+1, y], [x+1, y+1], [x, y+1]]);

			//error: All layer is not selected or layers are selected
			selection.similar(0, false);
		}
		catch(error:Dynamic){
			selectedSingleLayer = false;
		}

		selection.deselect();
		return selectedSingleLayer;
	}
	public static function hasPixel(layer:Layer):Bool
	{
		var bounds = layer.bounds;
		for (bound in bounds) if(bound == null) return false;
		return true;
	}
}
