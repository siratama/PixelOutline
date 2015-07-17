package psd_private;

@:native("ActionReference")
extern class ActionReference
{
	public function new();
	public function putName(typeId:Int, layerName:String):Void;
	public function putProperty(idChnl:Int, idfsel:Int):Void;
	public function putEnumerated(idChnl:Int, idChnl2:Int, trsp:Int):Void;
}
