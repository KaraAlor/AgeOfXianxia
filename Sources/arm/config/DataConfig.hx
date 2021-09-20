package arm.config;

import iron.system.Input;

@:enum
abstract KeyInput(Int) {
	var none = 0;
	var runkey = 1;
	var viewkey = 2;
	var lookkey = 3;
	var pausekey = 4;
	var forwardkey = 5;
	var backwardkey = 6;
	var leftkey = 7;
	var rightkey = 8;
	var jumpkey = 9;
	var crouchkey = 10;
}

@:enum
abstract KeySet(Int) {
	var none = 0;
	var keyboard = 1;
	var controller = 2;
	var mouse = 3;
}

class KeyBind {
	var DisplayName: String = "";

	var KeyboardKeys: Array<String>;
	var ControllerKeys: Array<String>;
	var MouseKeys: Array<String>;

	var delta: Bool = false;

	public function new(?Keyboard: Array<String>, ?Controller: Array<String>, ?Mouse: Array<String>, name: String) {
		KeyboardKeys = Keyboard != null ? Keyboard : [];
		ControllerKeys = Controller != null ? Controller : [];
		MouseKeys = Mouse != null ? Mouse : [];
		
		DisplayName = name;
		delta = false;
	}

	public function addkey(set: KeySet, key: String): Void {
		switch (set) {
			case none: return;
			case KeySet.keyboard: {
				KeyboardKeys.push(key);
			}
			case KeySet.controller: {
				ControllerKeys.push(key);
			}
			case KeySet.mouse: {
				MouseKeys.push(key);
			}
		}
	}

	public function popkey(set: KeySet): Void {
		switch (set) {
			case none: return;
			case KeySet.keyboard: {
				KeyboardKeys.pop();
			}
			case KeySet.controller: {
				ControllerKeys.pop();
			}
			case KeySet.mouse: {
				MouseKeys.pop();
			}
		}
	}

	public function removekey(set: KeySet, key: String): Void {
		switch (set) {
			case none: return;
			case KeySet.keyboard: {
				KeyboardKeys.remove(key);
			}
			case KeySet.controller: {
				ControllerKeys.remove(key);
			}
			case KeySet.mouse: {
				MouseKeys.remove(key);
			}
		}
	}

	public function clearkeys(set: KeySet): Void {
		switch (set) {
			case none: return;
			case KeySet.keyboard: {
				KeyboardKeys = [];
			}
			case KeySet.controller: {
				ControllerKeys = [];
			}
			case KeySet.mouse: {
				MouseKeys = [];
			}
		}
	}

	public function display(): String {
		return DisplayName;
	}

	public function displaykeys(set: KeySet): String {
		var str: String = "";
		switch (set) {
			case none: return "";
			case KeySet.keyboard: {
				for (key in KeyboardKeys) 
					str += key + " ";
			}
			case KeySet.controller: {
				for (key in ControllerKeys) 
					str += key + " ";
			}
			case KeySet.mouse: {
				for (key in MouseKeys) 
					str += key + " ";
			}
		}
		if (str.length > 0) return str.substr(0, str.length - 1);
		return str;
	}

	public function down(): Bool {
		//Get input devices
		var mouse = Input.getMouse();
		var keyboard = Input.getKeyboard();
		var gamepad = Input.getGamepad(0);

		for (key in KeyboardKeys) {
			if (!keyboard.down(key)) {
				break;
			}
			return true;
		}
		for (key in ControllerKeys) {
			if (gamepad.down(key) == 0) {
				break;
			}
			return true;
		}
		for (key in MouseKeys) {
			if (!mouse.down(key)) {
				break;
			}
			return true;
		}

		return false;
	}

	public function pressed(): Bool {
		if (down()){
			if (!delta){
				delta = true;
				return true;
			}
			return false;
		}
		delta = false;
		return false;
	}
}

class Global {
	//key binds
	public static var KeySetNames = ["", "Keyboard", "Controller", "Mouse"];
	public static var KeyDefaults: Array<KeyBind> = [null, 
		new KeyBind(["shift"], [], [], "Sprint Key"), 
		new KeyBind(["v"], [], [], "Mouse Look Key"),
		new KeyBind(["alt"], [], [], "View Key"),
		new KeyBind(["tab"], [], [], "Pause Menu Key"),
		new KeyBind(["w"], [], [], "Strafe Forward Key"),
		new KeyBind(["s"], [], [], "Strafe Backward Key"),
		new KeyBind(["a"], [], [], "Strafe Left Key"),
		new KeyBind(["d"], [], [], "Strafe Right Key"),
		new KeyBind(["space"], [], [], "Strafe Up(jump) Key"),
		new KeyBind(["ctrl"], [], [], "Strafe Down(crouch) Key")
	];

	//Key settings
    public static var MouseHorizontalScale: Float = 0.005;
    public static var MouseVerticalScale: Float = 0.005;

	//camera settings
	public static var DefaultFOV: Float = 90;
	public static var DefaultViewDistance: Float = 1000;
	public static var MinimumFOV: Float = 60;
	public static var MaximumFOV: Float = 120;
	public static var MinimumViewDistance: Float = 500;
	public static var MaximumViewDistance: Float = 2000;

	//ui settings
	public static var AimCursorScale: Float = 0.005;
	public static var AimCursorWidth: Float = 0.05;
}


//Config variables
class DataConfig {
	public var keybinds: Array<KeyBind> = Global.KeyDefaults;

	public var MouseVerticalScale = Global.MouseVerticalScale;
	public var MouseHorizontalScale = Global.MouseHorizontalScale;

	public var cam_fov = Global.DefaultFOV;
	public var cam_viewdistance = Global.DefaultViewDistance;

	public var AimCursorScale = Global.AimCursorScale;
	public var AimCursorWidth = Global.AimCursorWidth;
	
	public function new() {
	}

	public function keyDown(key: KeyInput): Bool{
		return keybinds[cast key].down();
	}

	public function keyPressed(key: KeyInput): Bool{
		return keybinds[cast key].pressed();
	}
}
