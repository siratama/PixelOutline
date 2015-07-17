package psd;

@:native("ArtLayers")
extern class ArtLayers implements ArrayAccess<ArtLayer>
{
	public function add():ArtLayer;
	public var length(default, null):Int;
	//public function index(index:Int):ArtLayer; //error
	public function getByName(nameParam:String):ArtLayer;
}
