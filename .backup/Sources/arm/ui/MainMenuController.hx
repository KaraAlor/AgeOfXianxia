package arm.ui;

import kha.Window;
import zui.*;
import iron.App;

import iron.Scene;
import kha.System;

import js.Browser;
import armory.data.Config;
import armory.renderpath.RenderPathCreator;

@:access(zui.Zui)
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

		var scale = winW / 1920;
		var origFontSize = ui.fontSize;

		var panW = Std.int(Math.min(50 + winW / 8, winW));
		var panX = Std.int(winW / 1000);
		var panY = Std.int(winH / 10);

        // Start with UI
        ui.begin(g);
        // Make region
		ui.beginRegion(g, panX, panY, panW);
		// ui.setScale(1);
		ui.fontSize = Std.int(ui.fontSize * 3 * scale);
		ui.text("Age Of Xianxia");
		ui.fontSize = Std.int(ui.fontSize / 3 * 1.5);
		
		ui.text("");

		ui.row([1/32, 31/32]);
		ui.text("");
		if (ui.button("Start Game")) {
			Scene.setActive("GameSpace");
		}

		ui.text("");

		ui.row([1/32, 31/32]);
		ui.text("");
		if (ui.button("Settings")) {
			settingsMenu.visible = true;
			graphicsMenu.visible = false;
		}

		ui.text("");

		ui.row([1/32, 31/32]);
		ui.text("");
		if (ui.button("Graphics")) {
			graphicsMenu.visible = true;
			settingsMenu.visible = false;
		}

		ui.text("");

		ui.row([1/32, 31/32]);
		ui.text("");
		if (ui.button("Quit")) {
			System.stop();
		}

		ui.fontSize = origFontSize;
		ui.endRegion();
        ui.end();

        g.begin(false);
	}
}
