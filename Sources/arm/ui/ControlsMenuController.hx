package arm.ui;

import kha.FastFloat;
import zui.*;
import iron.App;

import arm.DataConfig;
import iron.system.Storage;
import kha.input.Keyboard;

class ControlsMenuController extends iron.Trait {
	// Retrieve storage
	static var data: DataConfig = Storage.data.config;
	// UI
    var ui:Zui;
    public var visible: Bool = false;
	var selectedKeyInput: KeyInput = KeyInput.none;
	var selectedText: String = "";
	
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
        data = new DataConfig();
		if (null == data){
			data = new DataConfig();
			Storage.save();
		}
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
        // Make window
        if (ui.window(Id.handle(), panX, panY, panW, panH, true)) {
            // Make tabs in this window
            for (set in AllValues.list(DataConfig.KeySet)) {
                if (set == DataConfig.KeySet.none) continue;
                if (ui.tab(Id.handle(), Global.KeySetNames[cast set])) {
                    ui.indent();

                    ui.text("");

                    if (none != selectedKeyInput) {
                        var key = listenToKey();
                        if (null != key) {
                            if (selectedKeyInput != DataConfig.KeyInput.none && data.keybinds != null && data.keybinds[cast selectedKeyInput] != null) {
                                data.keybinds[cast selectedKeyInput].addkey(set, key);
                                selectedKeyInput = null;
                            }
                        }
                    }

                    for (keybind in  AllValues.list(DataConfig.KeyInput)) {
                        if (keybind == DataConfig.KeyInput.none) continue;
                        if (data.keybinds == null) continue;
                        if (data.keybinds[cast keybind] == null) continue;

                        ui.row([8/16, 5/16, 1/16, 1/16, 1/16]);
                        ui.text(data.keybinds[cast keybind].display());

                        if (selectedKeyInput == keybind) {
                            ui.text(selectedText);
                            if (ui.button("+")) {
                                selectedKeyInput = none;
                            }
                            if (ui.button("-")) {
                                data.keybinds[cast keybind].popkey(set);
                            }
                            if (ui.button("_")) {
                                data.keybinds[cast keybind].clearkeys(set);
                            }
                        } else {
                            ui.text(data.keybinds[cast keybind].displaykeys(set));
                            if (ui.button("+")) {
                                selectedKeyInput = keybind;
                            }
                            if (ui.button("-")) {
                                data.keybinds[cast keybind].popkey(set);
                            }
                            if (ui.button("_")) {
                                data.keybinds[cast keybind].clearkeys(set);
                            }
                        }
                    }

                    ui.text("");

                    // Apply button
                    ui.row([1/3, 1/3, 1/3]);
                    if (ui.button("Apply")) {
                        Storage.save();
                    }
                    ui.text("");
                    // Close button
                    if (ui.button("Close")) {
                        visible = false;
                    }
                    ui.unindent();
                }
            }
        }
        ui.end();

        g.begin(false);
	}

	function listenToKey(): String {
		if (ui.isKeyDown) {
			selectedText = iron.system.Input.Keyboard.keyCode(ui.key);
			ui.isTyping = false;

			if (Keyboard.get() != null) Keyboard.get().hide();
			return selectedText;
		}
		else {
			selectedText = "Press a key...";
			return null;
		}
	}
}
