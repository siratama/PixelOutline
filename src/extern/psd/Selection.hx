package psd;

@:native("Selection")
extern class Selection
{
	public function clear():Void;
	public function copy(merge:Bool):Void;
	public function deselect():Void;
	public function select(region:Array<Array<Int>>, type:SelectionType = null, feather:Int = 0, antiAlias:Bool = true):Void;
	public function selectAll():Void;
	public function selectBorder(width:String):Void;
	public function fill(fillType:Dynamic, mode:ColorBlendMode = null, opacity:Int = 100, preserveTransparency:Bool = false):Void;
	public function similar(tolerance:Int, antiAlias:Bool):Void;
	public function grow(tolerance:Int, antiAlias:Bool):Void;
	public function invert():Void;
	public function contract(by:String):Void;
	public function store(into:Channel, combination:SelectionType):Void;
	public function stroke(strokeColor:Dynamic, width:Float, location:StrokeLocation = null, mode:ColorBlendMode = null, opacity:Float = 100, preserveTransparency:Null<Bool> = null):Void;
}
