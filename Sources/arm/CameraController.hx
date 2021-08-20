package arm;

import iron.math.Quat;
import iron.math.Mat4;
import js.html.TableCaptionElement;
import iron.data.Armature.TAction;
import iron.object.BoneAnimation;
import Math;
import iron.Scene;
import iron.system.Input;
import iron.math.Vec2;
import iron.math.Vec4;
import iron.math.Mat4;
import iron.data.SceneFormat;
import iron.data.Armature;

class CameraController extends iron.Trait {
	//Properties
	@prop var HeadPitchOffset = 15;
    @prop var TPviewMin = 2.0;
    @prop var TPviewMax = 10.0;
    @prop var MouseHorizontalScale = 1/200;
    @prop var MouseVerticalScale = 1/200;

	//Get our Player objects
	var cameraParent = Scene.active.getEmpty("PlyHead");
	var camera = Scene.active.getCamera("PlyCamera");
	var playerRoot = Scene.active.getEmpty("PlyRoot");
	var playerSkeleton:BoneAnimation;

	//Current camera parameters
	var viewerDistance = 0.0;
	var viewerAzimuth = 0.0;
	var viewerAltitude = 0.0;


    public function new(){
        super();

        viewerDistance = camera.transform.loc.x;
		playerSkeleton = cameraParent.getParentArmature("PlyArmature");
        notifyOnUpdate(update);

		// notifyOnInit(function() {
		// });

		// notifyOnRemove(function() {
		// });
    }

    function update(){
		//Get input devices
		var mouse = Input.getMouse();
		var keyboard = Input.getKeyboard();
		var gamepad = Input.getGamepad(0);

		if ((keyboard != null && keyboard.down("left")) ||
			(keyboard != null && keyboard.down("a")) || 
			(gamepad != null && gamepad.down("left") > 0.0)){};

		if ((keyboard != null && keyboard.down("right")) || 
			(keyboard != null && keyboard.down("d")) ||
			(gamepad != null && gamepad.down("right") > 0.0)){};
		
		if ((keyboard != null && keyboard.down("up")) || 
			(keyboard != null && keyboard.down("w")) ||
			(gamepad != null && gamepad.down("up") > 0.0)){};
		
		if ((keyboard != null && keyboard.down("down")) ||
			(keyboard != null && keyboard.down("s")) || 
			(gamepad != null && gamepad.down("down") > 0.0)){};

		if (cameraParent != null){
			if (mouse != null && mouse.down("right")){
				if (playerSkeleton != null){
					playerSkeleton.play("LookRight");
				}
			};
			if (mouse != null && mouse.down("left")){
				if (playerSkeleton != null){
					playerSkeleton.play("LookLeft");
				}
			};
		
			if (keyboard != null && keyboard.down("alt")){
				rotateView(new Vec2(-mouse.movementX, -mouse.movementY));
			};
		
			if (mouse != null && mouse.wheelDelta != 0){
				zoomView(mouse.wheelDelta);
			};
		};
    }

	function zoomView(delta){
		viewerDistance += delta;
		viewerDistance = Math.min(Math.max(viewerDistance, TPviewMin),TPviewMax);
		camera.transform.loc = new Vec4(0, 0, viewerDistance, 0);
		camera.transform.buildMatrix();
	}

	function rotateView(angles:Vec2){
		viewerAzimuth += angles.x * MouseHorizontalScale;
		playerRoot.transform.setRotation(0, 0, viewerAzimuth);
		playerRoot.transform.buildMatrix();
		viewerAltitude += angles.y * MouseVerticalScale;
		
		cameraParent.transform.setRotation(viewerAltitude - HeadPitchOffset, 0, 0);
		cameraParent.transform.buildMatrix();
	}
}
