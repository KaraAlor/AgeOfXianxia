package arm.ui;

import zui.*;
import iron.App;

import arm.DataConfig;
import iron.system.Storage;
import kha.input.Keyboard;

class SettingsMenuController extends iron.Trait {
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
            // Make panel in this window
            if (ui.panel(Id.handle({selected: true}), "Settings")) {
                ui.indent();

                ui.text("");

                ui.row([2/3, 1/3]);
                ui.text("Run Key");
                if (selectedKeyInput == runkey) {
                    if (ui.button(selectedText)) {
                        selectedKeyInput = none;
                    }
                } else {
                    if (ui.button(data.key_run)) {
                        selectedKeyInput = runkey;
                    }
                }

                ui.row([2/3, 1/3]);
                ui.text("Mouse Look Key");
                if (selectedKeyInput == lookkey) {
                    if (ui.button(selectedText)) {
                        selectedKeyInput = none;
                    }
                } else {
                    if (ui.button(data.key_mouselook)) {
                        selectedKeyInput = lookkey;
                    }
                }

                ui.row([2/3, 1/3]);
                ui.text("View Key");
                if (selectedKeyInput == viewkey) {
                    if (ui.button(selectedText)) {
                        selectedKeyInput = none;
                    }
                } else {
                    if (ui.button(data.key_viewmode)) {
                        selectedKeyInput = viewkey;
                    }
                }

                ui.row([2/3, 1/3]);
                ui.text("Pause Menu Key");
                if (selectedKeyInput == pausekey) {
                    if (ui.button(selectedText)) {
                        selectedKeyInput = none;
                    }
                } else {
                    if (ui.button(data.key_pausemenu)) {
                        selectedKeyInput = pausekey;
                    }
                }

                if (none != selectedKeyInput) {
                    var key = listenToKey();
                    if (null != key) {
                        switch (selectedKeyInput) {
                            case none: {}
                            case runkey: {
                                data.key_run = key;
                                Storage.save();
                            }
                            case lookkey: {
                                data.key_mouselook = key;
                                Storage.save();
                            }
                            case viewkey: {
                                data.key_viewmode = key;
                                Storage.save();
                            }
                            case pausekey: {
                                data.key_pausemenu = key;
                                Storage.save();
                            }
                        }
                        selectedKeyInput = null;
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
