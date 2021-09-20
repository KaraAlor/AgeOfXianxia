package arm.ui;

import arm.config.*;
import arm.config.DataConfig;
import iron.system.Storage;
import iron.system.Input;

import zui.*;
import iron.App;
import iron.Trait;
import iron.Scene;

import iron.math.Vec2;
import iron.math.Vec4;

import iron.object.Transform;
import armory.trait.physics.RigidBody;

@:access(zui.Zui)
class AnimEditorController extends Trait {
	// Storage
	static var data: DataConfig;
	// UI
    var ui:Zui;
    var visible: Bool = true;
	var pauseMenu: PauseMenuController;
	// Current camera parameters
	@prop var WalkSpeed: Float = 5.0;
	@prop var RunSpeed: Float = 7.5;
	var dir = new Vec4();
	var viewerAzimuth = 0.0;
	var viewerAltitude = (Math.PI/2);
	var body: RigidBody = null;
	var transform: Transform = null;
	
	public function new() {
		super();

        // Load font for UI labels
        iron.data.Data.getFont("font_default.ttf", function(f:kha.Font) {
            ui = new Zui({font: f});
            iron.Scene.active.notifyOnInit(init);
        });
	}

	public override function remove() {
	}

	function init() {
        // last loading check
        data = Storage.data.config;
        if (null == data) {
            data = new DataConfig();
        }
		body = object.getTrait(RigidBody);
		transform = object.transform;

        pauseMenu = new PauseMenuController(closePauseMenu);

        notifyOnRender2D(render2D);
        notifyOnUpdate(update);
	}

    function update() {
        // locking mouse or unlocking
        var mouse = Input.getMouse();
        if (visible) {
            //camera angles
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
                    rotateView(new Vec2(-mouse.movementX * data.MouseHorizontalScale, -mouse.movementY * data.MouseVerticalScale));
                };
            }
            //movement
            dir.set(0, 0, 0);
		    var moveForward = false, moveBackward = false, moveLeft = false, moveRight = false, Jump = false, Crouch = false;
            if (data.keyDown(DataConfig.KeyInput.forwardkey)) {
                moveForward = true;
                dir.add(transform.look());
            }
            if (data.keyDown(DataConfig.KeyInput.backwardkey)) {
                moveBackward = true;
                dir.add(transform.look().mult(-1));
            }
            if (data.keyDown(DataConfig.KeyInput.leftkey)) {
                moveLeft = true;
                dir.add(transform.right().mult(-1));
            }
            if (data.keyDown(DataConfig.KeyInput.rightkey)) {
                moveRight = true;
                dir.add(transform.right());
            }
            //running
            var speed = WalkSpeed / 100;
            if (data.keyDown(DataConfig.KeyInput.runkey)) speed = RunSpeed / 100;

            //normalize
			dir = dir.normalize();
			//speed
			dir.mult(speed);
			
			Scene.active.camera.transform.translate(dir.x, dir.y, dir.z);
        }
        // pause menu key
        if (data.keyPressed(DataConfig.KeyInput.pausekey)) {
            if (visible) {
                mouse.unlock();
                pauseMenu.visible = true;
                visible = false;
            } else {
                pauseMenu.visible = false;
                visible = true;
            }
        }
    }

    public function closePauseMenu(){
        pauseMenu.visible = false;
        visible = true;
    }

	function render2D(g:kha.graphics2.Graphics) {
        if (!visible) return;

        g.end();

		var winW = App.framebuffer.width;
		var winH = App.framebuffer.height;

		var panW = Std.int(winW / 2);
		var panH = Std.int(winH / 2);
		var panX = Std.int(winW / 4);
		var panY = Std.int(winH / 4);

        // Start with UI
        ui.begin(g);
        ui.end();

        g.begin(false);
	}

	function rotateView(angles: Vec2){
		viewerAzimuth = (viewerAzimuth + angles.x) % (Math.PI * 2);
		viewerAltitude = (viewerAltitude + angles.y) % (Math.PI * 2);

		Scene.active.camera.transform.setRotation(viewerAltitude, 0, viewerAzimuth);
		Scene.active.camera.transform.buildMatrix();
	}
}