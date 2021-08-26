package arm;

import bullet.Bt.DefaultCollisionConfiguration;
import iron.system.Storage;

//default settings
var DefaultLookKey = "alt";
var DefaultRunKey = "shift";
var DefaultFOV = 90;
var DefaultViewDistance = 1000;

//settings bounds
var MinimumFOV = 60;
var MaximumFOV = 120;
var MinimumViewDistance = 500;
var MaximumViewDistance = 2000;

//Config variables
class DataConfig {
	public var cam_fov: Float;
	public var cam_viewdistance: Float;
	public var key_mouselook: String;
	public var key_run: String;
	
	public function new() {
		cam_fov = DefaultFOV;
		cam_viewdistance = DefaultViewDistance;
		key_mouselook = DefaultLookKey;
		key_run = DefaultRunKey;
	}
}
