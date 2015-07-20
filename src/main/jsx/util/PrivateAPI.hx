package jsx.util;

import psd.Layer;
import psd_private.CharacterID;
import psd_private.Lib;
import psd_private.DialogModes;
import psd_private.ActionReference;
import psd_private.ActionDescriptor;

class PrivateAPI
{
	public static function selectShapeBorder(layer:Layer)
	{
		var originalLayerName = layer.name;
		layer.name = "_____temp_layer_name_____ ";
		var layerName = layer.name;

		var idsetd = Lib.charIDToTypeID(CharacterID.SETD);
		var desc = new ActionDescriptor();
		var idnull = Lib.charIDToTypeID(CharacterID.NULL);
		var ref = new ActionReference();
		var idChnl = Lib.charIDToTypeID(CharacterID.CHNL);
		var idfsel = Lib.charIDToTypeID(CharacterID.FSEL);
		ref.putProperty(idChnl, idfsel);
		desc.putReference(idnull, ref);

		var idT = Lib.charIDToTypeID(CharacterID.T);
		var ref2 = new ActionReference();
		ref2.putEnumerated(
			Lib.charIDToTypeID(CharacterID.CHNL),
			Lib.charIDToTypeID(CharacterID.CHNL),
			Lib.charIDToTypeID(CharacterID.TRSP)
		);

		var idLyr = Lib.charIDToTypeID(CharacterID.LAYER);
		ref2.putName(idLyr, layerName);

		desc.putReference(idT, ref2);
		Lib.executeAction(idsetd, desc, DialogModes.NO);

		layer.name = originalLayerName;
	}
}
