package common;

enum PixelOutlineInitialErrorEvent
{
	NONE;
	ERROR(error:PixelOutlineInitialError);
}

@:enum abstract PixelOutlineInitialError(String)
{
	var UNOPENED_DOCUMENT = "unopened document";
	var UNSELECTED_SINGLE_LAYER = "selected layer set";
	var SELECTED_LAYER_SET = "unselected single layer";
	var SELECTED_BACKGROUND_LAYER = "selected locked layer";
	var SELECTED_LOCKED_LAYER = "selected background layer";
	var SELECTED_TRANSPARENT_LAYER = "selected transparent layer";
}
