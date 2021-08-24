package arm;

import armory.trait.Character;
import Math;
import iron.Scene;
import iron.Trait;
import iron.math.Vec2;
import iron.math.Vec3;
import iron.math.Vec4;
import iron.math.Mat4;
import iron.math.Quat;
import iron.system.Input;
import iron.system.Time;
import iron.system.Audio;
import iron.object.Object;
import iron.data.SceneFormat;
import iron.object.Transform;
import iron.object.MeshObject;
import iron.object.BoneAnimation;
import armory.trait.physics.PhysicsWorld;
import armory.trait.internal.CameraController;
import bullet.Bt.KinematicCharacterController;

class AoxCharController extends CameraController {
	#if (!arm_physics)
	public function new() { super(); }
	#else

	//Properties
    @prop var TPviewMin = 2.0;
    @prop var TPviewMax = 10.0;
    @prop var MouseHorizontalScale: Float = 0.005;
    @prop var MouseVerticalScale: Float = 0.005;
	@prop var WalkSpeed: Float = 1.0;
	@prop var RunSpeed: Float = 1.6;
	@prop var playerRoot: Object = null;
	@prop var armature: Object = null;
	@prop var cameraParent: Object = null;
	@prop var cameraObj: Object = null;

	//Misc
	var stepTime = 0.0;
	var firingTime = 0.0;
	var soundStep0:kha.Sound = null;
	var soundStep1:kha.Sound = null;

	//Current camera parameters
	var viewerDistance = 0.0;
	var viewerAzimuth = 0.0;
	var viewerAltitude = 0.0;
	var viewerRoll = 0.0;

	var dir = new Vec4();
	var lastLook:Vec4;

	//Animation Properties
	var state = "idle";
	var anim: BoneAnimation;

    public function new(){
        super();
        
		notifyOnInit(init);
    }

	function init(){
		if (!body.ready || null == playerRoot) return;

		PhysicsWorld.active.notifyOnPreUpdate(preUpdate);
		notifyOnUpdate(update);
		notifyOnLateUpdate(lateUpdate);
		notifyOnRemove(removeFromWorld);

		iron.data.Data.getSound("step0.wav", function(sound:kha.Sound) {
			soundStep0 = sound;
		});

		iron.data.Data.getSound("step1.wav", function(sound:kha.Sound) {
			soundStep1 = sound;
		});

		anim = findAnimation(armature);
		anim.notifyOnUpdate(updateBones);
		lastLook = armature.transform.look().normalize();
        viewerDistance = cameraObj.transform.loc.x;
	}

	function preUpdate() {
		if (Input.occupied || !body.ready) return;
		
		var mouse = Input.getMouse();
		var keyboard = Input.getKeyboard();
		
		// locking mouse or unlocking
		if (mouse.started() && !mouse.locked) mouse.lock();
		else if (keyboard.started("alt") && mouse.locked) mouse.unlock();

		// moving camera
		if (cameraParent != null){
			if (mouse != null && mouse.down("right")){
			};
			if (mouse != null && mouse.down("left")){
			};
		
			if (keyboard != null && mouse.locked && mouse.moved){
				rotateView(new Vec2(-mouse.movementX, -mouse.movementY));
			};
		
			if (mouse != null && mouse.wheelDelta != 0){
				zoomView(mouse.wheelDelta);
			};
		};

		body.syncTransform();
	}

    function update(){
		if (!body.ready) return;
		//Get input devices
		var mouse = Input.getMouse();
		var keyboard = Input.getKeyboard();
		var gamepad = Input.getGamepad(0);

		//gravity and friction
		var grav = body.body.getGravity();
		var grav4 = new Vec4(grav.x(), grav.y(), grav.z(), 0);
		var vel = body.getLinearVelocity();
		var gravVel = vel.sub(vel.cross(grav4)).add(grav4);
		body.setLinearVelocity(gravVel.x, gravVel.y, gravVel.z);

		//movement
		var look = armature.transform.look().normalize();
		dir.set(0, 0, 0);
		if (moveForward) dir.add(transform.look());
		if (moveBackward) dir.add(transform.look().mult(-1));
		if (moveLeft) dir.add(transform.right().mult(-1));
		if (moveRight) dir.add(transform.right());

		//running
		var speed = WalkSpeed;
		if (keyboard.down("shift")) speed = RunSpeed;

		//movement animation
		if (moveForward || moveBackward || moveLeft || moveRight) {
			var action = moveForward  ? "run"  :
						 moveBackward ? "back" :
						 moveLeft     ? "left" : "right";
			setState(action);
			//normalize
			dir = dir.normalize();
			//speed
			dir.mult(speed * 5);
			body.activate();
			body.setLinearVelocity(dir.x, dir.y, dir.z);
			//step sounds
			stepTime += Time.delta;
			if (stepTime > 0.38 / speed) {
				stepTime = 0;
				Audio.play(Std.random(2) == 0 ? soundStep0 : soundStep1);
			}
		} else {
			setState("idle", 2.0);
			stepTime = 0;
		}

		if (state == "fire") firingTime += Time.delta;
		else firingTime = 0.0;

		//Keep vertical
		body.setAngularFactor(0, 0, 0);
		//rebuild camera and fix armature
		lastLook.setFrom(look);
    }

	function lateUpdate(){
		if (!body.ready) return;
	}

	function updateBones() {
		var q = new Quat();
		var mat = Mat4.identity();
		// Fetch bone
		var bone1 = anim.getBone("mixamorig:LeftForeArm");
		var bone2 = anim.getBone("mixamorig:RightForeArm");

		// Fetch bone matrix - this is in local bone space for now
		var m1 = anim.getBoneMat(bone1);
		var m2 = anim.getBoneMat(bone2);
		var m1b = anim.getBoneMatBlend(bone1);
		var m2b = anim.getBoneMatBlend(bone2);
		var a1 = anim.getAbsMat(bone1.parent);
		var a2 = anim.getAbsMat(bone2.parent);

		// Rotate hand bones to aim with gun
		// Some raw math follows..
		var tx = m1._30;
		var ty = m1._31;
		var tz = m1._32;
		m1._30 = 0;
		m1._31 = 0;
		m1._32 = 0;
		mat.getInverse(a1);
		q.fromAxisAngle(mat.right(), viewerAltitude);
		m1.applyQuat(q);
		m1._30 = tx;
		m1._31 = ty;
		m1._32 = tz;
		
		var tx = m2._30;
		var ty = m2._31;
		var tz = m2._32;
		m2._30 = 0;
		m2._31 = 0;
		m2._32 = 0;
		mat.getInverse(a2);
		var v = mat.right();
		v.mult(-1);
		q.fromAxisAngle(v, -viewerAltitude);
		m2.applyQuat(q);
		m2._30 = tx;
		m2._31 = ty;
		m2._32 = tz;

		// Animation blending is in progress, we need to rotate those bones too
		if (m1b != null && m2b != null) {
			var tx = m1b._30;
			var ty = m1b._31;
			var tz = m1b._32;
			m1b._30 = 0;
			m1b._31 = 0;
			m1b._32 = 0;
			mat.getInverse(a1);
			q.fromAxisAngle(mat.right(), viewerAltitude);
			m1b.applyQuat(q);
			m1b._30 = tx;
			m1b._31 = ty;
			m1b._32 = tz;
			
			var tx = m2b._30;
			var ty = m2b._31;
			var tz = m2b._32;
			m2b._30 = 0;
			m2b._31 = 0;
			m2b._32 = 0;
			mat.getInverse(a2);
			var v = mat.right();
			v.mult(-1);
			q.fromAxisAngle(v, -viewerAltitude);
			m2b.applyQuat(q);
			m2b._30 = tx;
			m2b._31 = ty;
			m2b._32 = tz;
		}
	}

	function removeFromWorld(){
		PhysicsWorld.active.removePreUpdate(preUpdate);
	}

	function findAnimation(obj: Object): BoneAnimation{
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
		cameraObj.transform.loc = new Vec4(0, 0, viewerDistance, 0);
		cameraObj.transform.buildMatrix();
	}

	function rotateView(angles: Vec2){
		viewerAzimuth += angles.x * MouseHorizontalScale;
		playerRoot.transform.setRotation(0, 0, viewerAzimuth);
		playerRoot.transform.buildMatrix();
		viewerAltitude += angles.y * MouseVerticalScale;
		
		cameraParent.transform.setRotation(viewerAltitude, viewerRoll, 0);
		cameraParent.transform.buildMatrix();
	}

	function setState(animStr:String, speed = 1.0, blend = 0.2) {
		if (animStr == state) return;
		state = animStr;
		anim.play(animStr, null, blend, speed);
	}
	#end
}
