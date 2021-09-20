package arm.world;

import armory.trait.physics.RigidBody;
import arm.character.PlayerCharController;

import iron.Scene;
import iron.data.SceneFormat;
import iron.data.Data;
import iron.object.Object;

class Gamespace extends iron.Trait {
	public function new() {
		super();

		notifyOnInit(init);
	}

	function init() {
		Data.getSceneRaw("Reference", function (raw:TSceneFormat) {
			var player = Scene.getRawObjectByName(raw, "Player_proxy");
			var camera = Scene.getRawObjectByName(raw, "Camera_proxy");
			var cameraorgin = Scene.getRawObjectByName(raw, "CameraOrigin_proxy");
			var rig = Scene.getRawObjectByName(raw, "Metarig_proxy");
			var bot = Scene.getRawObjectByName(raw, "Bot_proxy");

			Scene.active.createObject(player, raw, null, null, function(ply: Object) {
				Scene.active.createObject(cameraorgin, raw, ply, player, function(corig: Object) {
					Scene.active.createObject(camera, raw, corig, cameraorgin, function(cam: Object) {
						Scene.active.createObject(rig, raw, ply, player, function(metarig: Object) {
							Scene.active.createObject(bot, raw, metarig, rig, function(rigmdl: Object) {
								ply.addChild(metarig);
								ply.addChild(corig);

								ply.transform.loc.set(Math.random() * 8 - 4, Math.random() * 8 - 4, 5);
								ply.transform.buildMatrix();

								ply.addTrait(new RigidBody(armory.trait.physics.bullet.RigidBody.Shape.Cylinder, 1.0, 0.5, 0.0, 1, 1, null, null));
								ply.addTrait(new PlayerCharController(ply, metarig, corig, cam, Scene.active.cameras[Scene.active.cameras.length - 1]));
								Scene.active.camera = Scene.active.cameras[Scene.active.cameras.length - 1];
							});
						});
					});
				});
            });
		});
	}
}