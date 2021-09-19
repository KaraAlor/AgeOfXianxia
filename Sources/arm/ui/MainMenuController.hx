package arm.ui;

import zui.*;
import iron.App;

import iron.Scene;
import kha.System;

@:access(zui.Zui)
class MainMenuController extends iron.Trait {
	// UI
    var ui: Zui;
	
	var controlsMenu: ControlsMenuController = new  ControlsMenuController();
	var graphicsMenu: GraphicsMenuController = new GraphicsMenuController();
	var creditsMenu: CreditsMenuController = new CreditsMenuController();

	var settingsExpand: Bool = false;
	var workshopExpand: Bool = false;
	
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

		var scale = winW / 1280;

		var origFontSize = ui.fontSize;
		var origElemH = ui.t.ELEMENT_H;
		var origElemW = ui.t.ELEMENT_W;
		var origElemOff = ui.t.ELEMENT_OFFSET;
		var origButtonH = ui.t.BUTTON_H;

		var panW = Std.int(Math.min(50 + winW / 6, winW));
		var panX = Std.int(winW / 1000);
		var panY = Std.int(winH / 10);

        // Start with UI
        ui.begin(g);
        // Make region
		ui.beginRegion(g, panX, 0, panW);

		ui.fill(0, 0, panW, winH, 0xaa101010);

		ui.t.ELEMENT_OFFSET = panY;
		ui.text("");

		ui.t.ELEMENT_OFFSET = origElemOff;
		ui.fontSize = Std.int(ui.fontSize * scale + 10);
		ui.t.ELEMENT_H = ui.fontSize + Std.int(4 * scale);
		ui.text("Age Of Xianxia");

		ui.fontSize = Std.int((ui.fontSize - 10) * 1.5);
		ui.t.ELEMENT_H = Std.int(30 * scale);
		ui.t.BUTTON_H = Std.int(30 * scale);
		ui.t.BUTTON_COL = 0xcc383838;
		ui.t.BUTTON_TEXT_COL = 0xaae8e7e5;
		ui.t.BUTTON_HOVER_COL = 0xaa252525;
		ui.t.BUTTON_PRESSED_COL = 0xaa1b1b1b;

		ui.row([1/32, 28/32]);
		ui.text("");
		if (ui.button("Start Game   ", zui.Zui.Align.Right)) {
			Scene.setActive("GameSpace");
		}

		ui.row([1/32, Std.int(28 - 3)/32]);
		ui.text("");
		if (ui.button("Workshop   ", zui.Zui.Align.Right)) {
			workshopExpand = !workshopExpand;
			settingsExpand = false;
			creditsMenu.visible = false;
		}

		if (workshopExpand) {
			ui.row([5/32, Std.int(24 - 4)/32]);
			ui.text("");
			if (ui.button("Animation Editor   ", zui.Zui.Align.Right)) {
				Scene.setActive("AnimEditor");
			}
			ui.row([5/32, Std.int(24 - 4)/32]);
			ui.text("");
			if (ui.button("World Builder   ", zui.Zui.Align.Right)) {
				Scene.setActive("MapEditor");
			}
		}

		ui.row([1/32, Std.int(28 - 6)/32]);
		ui.text("");
		if (ui.button("Settings   ", zui.Zui.Align.Right)) {
			settingsExpand = !settingsExpand;
			workshopExpand = false;
			creditsMenu.visible = false;
		}

		if (settingsExpand) {
			ui.row([5/32, Std.int(24 - 7)/32]);
			ui.text("");
			if (ui.button("Controls   ", zui.Zui.Align.Right)) {
				if (controlsMenu.visible){
					controlsMenu.visible = false;
				} else {
					controlsMenu.visible = true;
					creditsMenu.visible = false;
					graphicsMenu.visible = false;
				}
			}
			ui.row([5/32, Std.int(24 - 7)/32]);
			ui.text("");
			if (ui.button("Graphics   ", zui.Zui.Align.Right)) {
				if (graphicsMenu.visible) {
					graphicsMenu.visible = false;
				} else {
					graphicsMenu.visible = true;
					creditsMenu.visible = false;
					controlsMenu.visible = false;
				}
			}
		} else {
			controlsMenu.visible = false;
			graphicsMenu.visible = false;
		}


		ui.row([1/32, Std.int(28 - 9)/32]);
		ui.text("");
		if (ui.button("Credits   ", zui.Zui.Align.Right)) {
			if (creditsMenu.visible) {
				creditsMenu.visible = false;
			} else {
				creditsMenu.visible = true;
				settingsExpand = false;
				workshopExpand = false;
			}
		}

		ui.row([1/32, Std.int(28 - 12)/32]);
		ui.text("");
		if (ui.button("Quit   ", zui.Zui.Align.Right)) {
			System.stop();
		}

		ui.fontSize = origFontSize;
		ui.t.ELEMENT_H = origElemH;
		ui.t.ELEMENT_W = origElemW;
		ui.t.BUTTON_H = origButtonH;
		ui.endRegion();
        ui.end();

        g.begin(false);
	}
}
