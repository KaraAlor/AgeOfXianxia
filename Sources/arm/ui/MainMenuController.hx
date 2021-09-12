package arm.ui;

import kha.Window;
import zui.*;
import iron.App;

import iron.Scene;
import kha.System;

import js.Browser;
import armory.data.Config;
import armory.renderpath.RenderPathCreator;

class MainMenuController extends iron.Trait {
	// UI
    var ui: Zui;
	var settingsMenu: SettingsMenuController = new SettingsMenuController();
	var graphicsMenu: GraphicsMenuController = new GraphicsMenuController();
	
	public function new() {
		super();

        // Load font for UI labels
        iron.data.Data.getFont("font_default.ttf", function(f:kha.Font) {
            ui = new Zui({font: f});
            iron.Scene.active.notifyOnInit(init);
        });
	}

	function init() {
        notifyOnRender2D(render2D);
	}

	function render2D(g:kha.graphics2.Graphics) {
		g.end();
		

		var winW = App.framebuffer.width;
		var winH = App.framebuffer.height;

		var panW = Std.int(Math.min(300 + winW / 3, winW));
		var panH = Std.int(Math.min(500 + winH / 3, winH));

		var panX = Std.int(winW / 4);
		var panY = Std.int(winH / 4);

        // Start with UI
        ui.begin(g);
        // Make window
		if (ui.window(Id.handle(), panX, panY, panW, panH, false)) {
			if (ui.panel(Id.handle({selected: true}), "Age of Xianxia")) {
				ui.indent();

				ui.row([1/4, 1/2, 1/4]);
				ui.text("");
				if (ui.button("Start Game")) {
					Scene.setActive("GameSpace");
				}
				ui.text("");

				ui.text("");

				ui.row([1/4, 1/2, 1/4]);
				ui.text("");
				if (ui.button("Settings")) {
					settingsMenu.visible = true;
				}
				ui.text("");

				ui.text("");

				ui.row([1/4, 1/2, 1/4]);
				ui.text("");
				if (ui.button("Graphics")) {
					graphicsMenu.visible = true;
				}
				ui.text("");

				ui.text("");

				ui.row([1/4, 1/2, 1/4]);
				ui.text("");
				if (ui.button("Quit")) {
					System.stop();
				}
				ui.text("");

				ui.unindent();
			}
		}
        ui.end();

        g.begin(false);
	}
}
