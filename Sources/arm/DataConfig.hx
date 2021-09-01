package arm;

import bullet.Bt.DefaultCollisionConfiguration;
import iron.system.Storage;

class Global {
	//default settings
	public static var DefaultLookKey = "alt";
	public static var DefaultRunKey = "shift";
	public static var DefaultViewModeKey = "v";
	public static var DefaultPauseKey = "escape";
	public static var DefaultFOV = 90;
	public static var DefaultViewDistance = 1000;

	//settings bounds
	public static var MinimumFOV = 60;
	public static var MaximumFOV = 120;
	public static var MinimumViewDistance = 500;
	public static var MaximumViewDistance = 2000;
}
//Config variables
class DataConfig {
	public var cam_fov: Float = Global.DefaultFOV;
	public var cam_viewdistance: Float = Global.DefaultViewDistance;
	public var key_mouselook: String = Global.DefaultLookKey;
	public var key_run: String = Global.DefaultRunKey;
	public var key_viewmode: String = Global.DefaultViewModeKey;
	public var key_pausemenu: String = Global.DefaultPauseKey;
	
	public function new() {
	}
}
