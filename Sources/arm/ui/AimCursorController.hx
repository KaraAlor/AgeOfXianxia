package arm.ui;

import zui.*;
import iron.App;
import iron.data.Data;

import arm.config.*;
import arm.config.DataConfig;
import iron.system.Storage;

class AimCursorController {
	//Storage
	static var data: DataConfig = Storage.data.config;

	//GUI
    var ui:Zui;
    public var visible: Bool = true;

    public function new(){
        // Load font for UI labels
        Data.getFont("font_default.ttf", function(f:kha.Font) {
            ui = new Zui({font: f});
            iron.Scene.active.notifyOnInit(init);
        });
    }

	public function remove() {
	}

	function init(){
		if (null == data) {
			data = new DataConfig();
		}
        App.notifyOnRender2D(render2D);
	}

	function render2D(g:kha.graphics2.Graphics) {
        if (!visible) return;
		g.end();

		var winW = App.framebuffer.width;
		var winH = App.framebuffer.height;

		var aimw = Std.int(10 + winW / 2 * data.AimCursorScale);
		var aimx = Std.int(winW / 2 - aimw / 2);
		var aimy = Std.int(winH / 2 - aimw / 2);

        // Start with UI
        ui.begin(g);
            ui.beginRegion(g, 0, 0, winW);
            ui.fill(aimx, aimy + aimw / 2 - data.AimCursorWidth * aimw, aimw, data.AimCursorWidth * aimw, kha.Color.Red);
            ui.fill(aimx + aimw / 2 - data.AimCursorWidth * aimw, aimy, data.AimCursorWidth * aimw, aimw, kha.Color.Red);
            ui.endRegion();
        ui.end();

        g.begin(false);
	}
}
