package arm;

import iron.object.Object;
import iron.object.BoneAnimation;
import Math;
import iron.Scene;
import iron.system.Input;
import iron.math.Vec2;
import iron.math.Vec4;

class CameraController extends iron.Trait {
	//Properties
    @prop var TPviewMin = 2.0;
    @prop var TPviewMax = 10.0;
    @prop var MouseHorizontalScale = 1/200;
    @prop var MouseVerticalScale = 1/200;

	//Get our Player objects
	var cameraParent = Scene.active.getEmpty("PlyCameraRoot");
	var camera = Scene.active.getCamera("PlyCamera");
	var playerRoot = Scene.active.getEmpty("PlyRoot");
	var animation:BoneAnimation;

	//Current camera parameters
	var viewerDistance = 0.0;
	var viewerAzimuth = 0.0;
	var viewerAltitude = 0.0;


    public function new(){
        super();

        viewerDistance = camera.transform.loc.x;
		animation = findAnimation(playerRoot.getChild("PlySkeleton"));
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
				if (animation != null){
					animation.play("Attack_1");
				}
			};
			if (mouse != null && mouse.down("left")){
				if (animation != null){
					animation.play("Drop");
				}
			};
		
			if (keyboard != null && keyboard.down("alt")){
				rotateView(new Vec2(-mouse.movementX, mouse.movementY));
			};
		
			if (mouse != null && mouse.wheelDelta != 0){
				zoomView(mouse.wheelDelta);
			};
		};
    }

	function findAnimation(obj:Object):BoneAnimation{
		if (obj.animation != null){
			return cast obj.animation;
		}
		for (child in obj.children){
			var childAnim = findAnimation(child);
			if (childAnim != null){
				return childAnim;
			}
		}

		return null;
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
		
		cameraParent.transform.setRotation(viewerAltitude, 0, 0);
		cameraParent.transform.buildMatrix();
	}
}
