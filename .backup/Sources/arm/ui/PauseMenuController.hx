package arm.ui;

import zui.*;
import iron.data.Data;

import iron.App;
import iron.Scene;
import kha.System;

class PauseMenuController {
	//GUI
    var ui:Zui;
    public var visible: Bool = false;

    public function new(){
        // Load font for UI labels
        Data.getFont("font_default.ttf", function(f:kha.Font) {
            ui = new Zui({font: f});
            iron.Scene.active.notifyOnInit(init);
        });
    }

	function init(){
        App.notifyOnRender2D(render2D);
	}
	function render2D(g:kha.graphics2.Graphics) {
        if (!visible) return;
		g.end();

		var winW = App.framebuffer.width;
		var winH = App.framebuffer.height;

        // Start with UI
        ui.begin(g);
            var panW = Std.int(winW / 2);
            var panH = Std.int(winH / 2);
            var panX = Std.int(winW / 4);
            var panY = Std.int(winH / 4);
            if (ui.window(Id.handle(), panX, panY, panW, panH, false)) {
                ui.indent();
                
                ui.row([1/4, 1/2, 1/4]);
                ui.text("");
                if (ui.button("Return")) {
                    visible = false;
                }
                ui.text("");
                
                ui.text("");

                ui.row([1/4, 1/2, 1/4]);
                ui.text("");
                if (ui.button("Back to Main Menu")) {
                    Scene.setActive("MainMenu");
                }
                ui.text("");

                ui.text("");

                ui.row([1/4, 1/2, 1/4]);
                ui.text("");
                if (ui.button("Quit to Desktop")) {
                    System.stop();
                }
                ui.text("");
                
                ui.unindent();
            }
        ui.end();

        g.begin(false);
	}
}