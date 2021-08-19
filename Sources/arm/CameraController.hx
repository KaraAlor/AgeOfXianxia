package arm;

import iron.Scene;
import iron.system.Input;
import iron.math.Vec4;

class CameraController extends iron.Trait {
	//Get our Camera Parent
	var cameraParent = Scene.active.getEmpty("PlyHead");
    //Get mouse
    var mouse = Input.getMouse();

	//Properties
    @prop var viewMin = 1.0;
    @prop var viewMax = 2.8;

    public function new() {
        super();

        notifyOnUpdate(update);

		// notifyOnInit(function() {
		// });

		// notifyOnRemove(function() {
		// });
    }

    function update() {
        if(mouse.down("right")){
            // Rotate our empty on z-axis in opposite direction of our mouse-x movement.
            // Mouse movement is divided by 200 to slow the rotation.
            cameraParent.transform.rotate(new Vec4(0, 0, 1), -mouse.movementX / 200);
            cameraParent.transform.buildMatrix();
            cameraParent.transform.rotate(object.transform.world.right(), -mouse.movementY / 200);
            cameraParent.transform.buildMatrix();
        }

        if (mouse.wheelDelta != 0){
            //Add mouse wheel delta to cameraParent scale
            cameraParent.transform.scale.add(new Vec4(mouse.wheelDelta/30, mouse.wheelDelta/30, mouse.wheelDelta/30));
            //Clamp the scale
            cameraParent.transform.scale.clamp(viewMin, viewMax);
            cameraParent.transform.buildMatrix();
        }
    }
}
