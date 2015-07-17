package common;
enum PixelOutlineEvent
{
	NONE;
}
enum PixelOutlineInitialErrorEvent
{
	NONE;
	UNSELECTED_SINGLE_LAYER;
	SELECTED_LAYER_SET;
	SELECTED_BACKGROUND_LAYER;
	SELECTED_LOCKED_LAYER;
	ERROR(message:String);
}
