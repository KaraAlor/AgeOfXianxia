package arm.character;

import js.html.webgl.TransformFeedback;
import arm.ui.AimCursorController;
import arm.ui.PauseMenuController;
import zui.*;
import iron.App;
import kha.System;

import Math;
import iron.Scene;
import iron.Trait;

import iron.math.Vec2;
import iron.math.Vec3;
import iron.math.Vec4;
import iron.math.Mat4;
import iron.math.Quat;

import iron.system.Time;
import iron.system.Tween;
import iron.system.Input;
import iron.system.Audio;
import iron.system.Storage;

import arm.config.*;
import arm.config.DataConfig;
import armory.data.Config;
import iron.data.Data;
import iron.data.SceneFormat;

import iron.object.Object;
import iron.object.Transform;
import iron.object.MeshObject;
import iron.object.CameraObject;
import iron.object.BoneAnimation;

import armory.trait.Character;
import armory.trait.physics.RigidBody;
import armory.trait.physics.PhysicsWorld;
import armory.trait.navigation.Navigation;

class PlayerCharController extends Trait {
	//Properties
	@prop public var FPviewdist = 0.0;
    @prop public var TPviewMin = 1.0;
    @prop public var TPviewMax = 5.0;
	@prop public var TDviewMin = 5.0;
	@prop public var TDviewMax = 20.0;

	@prop public var WalkSpeed: Float = 5.0;
	@prop public var RunSpeed: Float = 7.5;
	@prop public var turnDuration: Float = 0.4;
	@prop public var StepDelay: Float = 1.5;

	@prop public var playerRoot: Object = null;
	@prop public var armature: Object = null;
	@prop public var cameraParent: Object = null;
	@prop public var cameraObj: Object = null;
	@prop public var cam: CameraObject = null;
	@prop public var body: RigidBody = null;
	@prop public var transform: Transform = null;

	//Storage
	static var data: DataConfig = Storage.data.config;

	//GUI
	var aimCursor: AimCursorController = new AimCursorController();
	var pauseMenu: PauseMenuController;
	var chatMenu: Bool = true;
	var characterMenu: Bool = false;
	var inventoryMenu: Bool = false;
	var skillsMenu: Bool = false;

	//Misc
	var firingTime = 0.0;
	var dir = new Vec4();

	//AI
	var path: Array<Vec4> = null;
	var index = 0;
	var locAnim: TAnim = null;
	var rotAnim: TAnim = null;
	
	//Sound
	var stepTime = 0.0;
	var soundStep0:kha.Sound = null;
	var soundStep1:kha.Sound = null;

	//Current camera parameters
	var viewerDistance = 0.0;
	var viewerAzimuth = 0.0;
	var viewerAltitude = 0.0;
	var modelAzimuth = 0.0;
	var cameraMode = 1; // 0 - First Person, 1 - Third Person, 2 - Top Down

	//Animation Properties
	var state = "idleGun";
	var anim: BoneAnimation;

	public function new(?proot: Object, ?arm: Object, ?cparent: Object, ?cobj: Object, ?camera: CameraObject, ?bdy: RigidBody, ?tform: Transform){
        super();

		if (null != proot) playerRoot = proot;
		if (null != arm) armature = arm;
		if (null != cparent) cameraParent = cparent;
		if (null != cobj) cameraObj = cobj;
		if (null != camera) cam = camera;
		if (null != bdy) body = bdy;
		if (null != tform) transform = tform;
        
		notifyOnInit(init);
    }

	function init(){
		//ensure our parameters are setup
		if (null == playerRoot || null == armature || null == cameraParent || null == cameraObj) {
			trace("error");
			return;
		}
		
		if (null == body) {
			if (null != object) body = object.getTrait(RigidBody);
			else body = playerRoot.getTrait(RigidBody);
		}
		if (null == body) {
			trace("error");
			return;
		}
		
		if (null == transform){
			if (null != object) transform = object.transform;
			else transform = playerRoot.transform;
		} 
		if (null == transform) {
			trace("error");
			return;
		}

		if (null == cam) {
			cam = Scene.active.cameras[Scene.active.cameras.length - 1];
		}
		if (null == cam) {
			trace("error");
			return;
		}

		Data.getSound("sounds/step0.wav", function(sound: kha.Sound) {
			soundStep0 = sound;
		});

		Data.getSound("sounds/step1.wav", function(sound: kha.Sound) {
			soundStep1 = sound;
		});

		pauseMenu = new PauseMenuController(closePauseMenu);
		anim = findAnimation(armature);
		//last loading check
		if (null == data) {
			data = new DataConfig();
		}
		if (null != anim) {
			anim.notifyOnUpdate(updateBones);
		}
		
        viewerDistance = cameraObj.transform.loc.x;

		PhysicsWorld.active.notifyOnPreUpdate(preUpdate);
		notifyOnUpdate(update);
		notifyOnLateUpdate(lateUpdate);
		notifyOnRemove(removeFromWorld);
		pauseMenu.visible = false;
	}

	function preUpdate() {
		if (Input.occupied || !body.ready) return;
		
		var mouse = Input.getMouse();
		var keyboard = Input.getKeyboard();
		if (mouse == null || keyboard == null){
			return;
		}
		
		if (canInteractWithGameWorld()) {
			// locking mouse or unlocking
			if (data.keyPressed(DataConfig.KeyInput.lookkey)){
				if (!mouse.locked) {
					mouse.reset();
					mouse.lock();
					mouse.hide();
				} else {
					mouse.unlock();
					mouse.show();
				}
			} else {
				// moving camera
				if (mouse.locked && mouse.moved){
					rotateView(new Vec2(-mouse.movementX * data.MouseHorizontalScale, mouse.movementY * data.MouseVerticalScale));
				};
				if (mouse.wheelDelta != 0){
					zoomView(mouse.wheelDelta);
				};
			}
		}
		body.syncTransform();
	}

    function update(){
		if (!body.ready) return;
		//Get input devices
		var mouse = Input.getMouse();
		var keyboard = Input.getKeyboard();
		// var gamepad = Input.getGamepad(0);

		//gravity and friction
		var grav = body.body.getGravity();
		var grav4 = new Vec4(grav.x(), grav.y(), grav.z(), 0);
		var vel = body.getLinearVelocity();
		var gravVel = vel.sub(vel.cross(grav4)).add(grav4);
		body.setLinearVelocity(gravVel.x, gravVel.y, gravVel.z);

		if (canInteractWithGameWorld()) {
			//view mode
			if (data.keyPressed(DataConfig.KeyInput.viewkey)) {
				cameraMode = (cameraMode + 1) % 3;

				zoomView(0);
				rotateView(new Vec2(0, 0));
			}
			if (data.keyPressed(DataConfig.KeyInput.pausekey)) {
				pauseMenu.visible = true;
				aimCursor.visible = false;
				mouse.unlock();
			}

			if (cameraMode != 2) {
				directControl();
			} else {
				navAgentControl();
				rotateView(new Vec2(0, 0));
				// setState("idleGun", 2.0);
			}
		} else {
			if (data.keyPressed(DataConfig.KeyInput.pausekey)) {
				pauseMenu.visible = false;
				aimCursor.visible = true;
			}
		}

		//Keep vertical
		body.setAngularFactor(0, 0, 0);
    }

	function directControl() {
		//movement
		dir.set(0, 0, 0);

		var moveForward = false, moveBackward = false, moveLeft = false, moveRight = false, Jump = false, Crouch = false;
		if (data.keyDown(DataConfig.KeyInput.forwardkey)) {
			moveForward = true;
			dir.add(transform.look().mult(-1));
		}
		if (data.keyDown(DataConfig.KeyInput.backwardkey)) {
			moveBackward = true;
			dir.add(transform.look());
		}
		if (data.keyDown(DataConfig.KeyInput.leftkey)) {
			moveLeft = true;
			dir.add(transform.right());
		}
		if (data.keyDown(DataConfig.KeyInput.rightkey)) {
			moveRight = true;
			dir.add(transform.right().mult(-1));
		}

		//running
		var speed = WalkSpeed;
		if (data.keyDown(DataConfig.KeyInput.runkey)) speed = RunSpeed;

		//movement animation
		if (moveForward || moveBackward || moveLeft || moveRight) {
			var action = moveForward  ? "runGun"  :
						 moveBackward ? "backGun" :
						 moveLeft     ? "leftGun" : "rightGun";
			// setState(action);
			//normalize
			dir = dir.normalize();
			//speed
			dir.mult(speed);
			dir.add(body.getLinearVelocity());
			
			body.activate();
			body.setLinearVelocity(dir.x, dir.y, dir.z);
			//step sounds
			stepTime += Time.delta;
			if (stepTime > StepDelay / speed) {
				stepTime = 0;
				if (null != soundStep0 && null != soundStep1){
					Audio.play(Std.random(2) == 0 ? soundStep0 : soundStep1);
				}
			}
		} else {
			// setState("idleGun", 2.0);
			stepTime = 0;
		}

		if (state == "fire") firingTime += Time.delta;
		else firingTime = 0.0;
	}

	function navAgentControl() {
		var mouse: Mouse = Input.getMouse();

		// if (mouse.down("left")){
		// 	var physics = PhysicsWorld.active;
		// 	var b = physics.pickClosest(mouse.x, mouse.y);
		// 	var rb = navObj.getTrait(RigidBody);

		// 	if (rb != null && b == rb) {
		// 		var from: Vec4 = playerRoot.transform.world.getLoc();
		// 		var to: Vec4 = physics.hitPointWorld;

		// 		Navigation.active.navMeshes[0].findPath(from, to, function(path: Array<Vec4>) {
		// 			setPath(path);
		// 		});
		// 	}
		// }
	}

	function lateUpdate(){
		if (!body.ready) return;
	}

	function updateBones() {
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
		if (cameraMode == 0) {
			viewerDistance = FPviewdist;
		} else if (cameraMode == 1) {
			viewerDistance = Math.min(Math.max(viewerDistance + delta, TPviewMin),TPviewMax);
		} else if (cameraMode == 2) {
			viewerDistance = Math.min(Math.max(viewerDistance + delta, TDviewMin),TDviewMax);
		}
		cameraObj.transform.loc.set(0, viewerDistance, 0);
		cameraObj.transform.buildMatrix();
	}

	function rotateView(angles: Vec2){
		viewerAzimuth = (viewerAzimuth + angles.x) % (Math.PI * 2);
		viewerAltitude = (viewerAltitude + angles.y) % (Math.PI * 2);

		if (cameraMode != 2) {
			modelAzimuth = viewerAzimuth;
		}

		playerRoot.transform.setRotation(0, 0, modelAzimuth);
		playerRoot.transform.buildMatrix();
		cameraParent.transform.setRotation(viewerAltitude, 0, (viewerAzimuth - modelAzimuth) % (Math.PI * 2));
		cameraParent.transform.buildMatrix();
	}

	function setState(animStr:String, speed = 1.0, blend = 0.2) {
		if (animStr == state) return;
		state = animStr;
		anim.play(animStr, null, blend, speed);
	}

	public function setPath(path: Array<Vec4>) {
		stopTween();

		this.path = path;
		index = 1;

		go();
	}

	function stopTween() {
		if (locAnim != null) Tween.stop(locAnim);
		if (rotAnim != null) Tween.stop(rotAnim);
	}

	function go() {
		if (path == null || index >= path.length) return;

		var p = path[index];
		var dist = Vec4.distance(object.transform.loc, p);

		var orient = new Vec4();
		orient.subvecs(p, object.transform.loc).normalize;
		var targetAngle = (Math.atan2(orient.y, orient.x) - Math.PI / 2);

		if (targetAngle - modelAzimuth > Math.PI) targetAngle -= Math.PI * 2;

		locAnim = Tween.to({ target: object.transform.loc, props: { x: p.x, y: p.y, z: p.z }, duration: dist / RunSpeed, done: function() {
			index++;
			if (index < path.length) go();
		}});

		rotAnim = Tween.to({ target: this, props: { modelAzimuth: targetAngle }, duration: turnDuration});
	}

	function canInteractWithGameWorld(): Bool {
		aimCursor.visible = !pauseMenu.visible;
		return !pauseMenu.visible;
	}
	
	public function closePauseMenu() {
		pauseMenu.visible = false;
		aimCursor.visible = true;
	}
}
