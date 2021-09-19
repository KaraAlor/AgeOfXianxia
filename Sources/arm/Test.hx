package arm;

import armory.trait.physics.bullet.RigidBody.Shape;
import iron.Scene;
import iron.data.SceneFormat;
import iron.data.Data;
import iron.system.Input;
import iron.object.Object;

class Test extends iron.Trait {
	var obj: TObj;
	var raw: TSceneFormat;

	public function new() {
		super();
		notifyOnInit(init);
	}

	function init() {
		Data.getSceneRaw("Reference", function (r:TSceneFormat) {
			obj = Scene.getRawObjectByName(r, "Sword_proxy");
			raw = r;
			notifyOnUpdate(update);
		});
	}

	function update() {
		// Left mouse button was pressed / display touched
		var mouse = Input.getMouse();
		if (mouse.down()) {
			// Create new object in active scene
			Scene.active.createObject(obj, raw, null, null, function(object: Object) {
				// Just for testing, add rigid body trait
				object.transform.loc.set(Math.random() * 8 - 4, Math.random() * 8 - 4, 5);
				object.transform.buildMatrix();
				object.addTrait(new armory.trait.physics.RigidBody(armory.trait.physics.bullet.RigidBody.Shape.Box, 1.0, 0.5, 0.0, 1, 1, null, null));
			});
		}
	}
}