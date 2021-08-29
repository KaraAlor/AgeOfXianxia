package arm;

import zui.Zui.Handle;
import zui.Zui.Align;
import zui.*;
import iron.App;

import arm.DataConfig;
import armory.data.Config;
import iron.system.Storage;

import iron.system.Input;
import kha.input.Keyboard;

import iron.Scene;
import kha.System;
import armory.renderpath.RenderPathCreator;

class MainMenuController extends iron.Trait {
	// Retrieve storage
	static var data: DataConfig = Storage.data.config;
	// UI
    var ui:Zui;
	var state: Int = 0; // 0 - main menu, 1 - settings, 2 - graphics
	var selectedHandle: Handle = null;
	var selectedText: String = "";
	var runHandle: Handle = Id.handle();
	
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
        notifyOnUpdate(update);

		if (null == data){
			data = new DataConfig();
			Storage.save();
		}
		if (null == data.cam_fov)
			data.cam_fov = DefaultFOV;
		if (null == data.cam_viewdistance)
			data.cam_viewdistance = DefaultViewDistance;
		if (null == data.key_mouselook)
			data.key_mouselook = DefaultLookKey;
		if (null == data.key_run)
			data.key_run = DefaultRunKey;
		if (null == data.key_viewmode)
			data.key_viewmode = DefaultViewModeKey;
	}

	function update() {

	}

	function render2D(g:kha.graphics2.Graphics) {
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
		if (state == 0) { // Main menu
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
						state = 1;
					}
					ui.text("");

					ui.text("");

					ui.row([1/4, 1/2, 1/4]);
					ui.text("");
					if (ui.button("Graphics")) {
						state = 2;
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
		} else if (state == 1) { // Settings
			if (ui.window(Id.handle(), panX, panY, panW, panH, true)) {
				// Make panel in this window
				if (ui.panel(Id.handle({selected: true}), "Settings")) {
					ui.indent();

					ui.text("");

					ui.row([2/3, 1/3]);
					if (ui.button("Run Key")){
						selectedHandle = runHandle;
					}
					if (selectedHandle == runHandle) {
						ui.textInput(runHandle, selectedText, Align.Left, false);
					} else {
						ui.textInput(runHandle, data.key_run, Align.Left, false);
					}

					if (null != selectedHandle) {
						var key = listenToKey();
						if (null != key) {
							switch (selectedHandle) {
								case runHandle: {
									data.key_run = key;
									Storage.save();
								}
							}
							selectedHandle = null;
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
						state = 0;
					}
					ui.unindent();
				}
			}
		} else if (state == 2) { // Graphics
			if (ui.window(Id.handle(), panX, panY, panW, panH, true)) {
				// Make panel in this window
				if (ui.panel(Id.handle({selected: true}), "Graphics")) {
					ui.indent();

					// Fullscreen checkbox
					var fullscreen = Config.raw.window_mode == 1;
					fullscreen = ui.check(Id.handle({selected: fullscreen}), "Fullscreen");
					Config.raw.window_mode = fullscreen ? 1 : 0;
					// SSAO checkbox
					Config.raw.rp_ssgi = ui.check(Id.handle({selected: Config.raw.rp_ssgi}), "SSAO");
					// SSAO checkbox
					Config.raw.rp_ssr = ui.check(Id.handle({selected: Config.raw.rp_ssr}), "SSR");
					// SSAO checkbox
					Config.raw.rp_bloom = ui.check(Id.handle({selected: Config.raw.rp_bloom}), "Bloom");
					// SSAO checkbox
					Config.raw.rp_motionblur = ui.check(Id.handle({selected: Config.raw.rp_motionblur}), "Motion Blur");

					ui.text("");

					// Shadows
					var shadows = getShadowQuality(Config.raw.rp_shadowmap_cascade);
					shadows = ui.combo(Id.handle({position: shadows}), ["High", "Medium", "Low"], "Shadows", true);
					Config.raw.rp_shadowmap_cascade = getShadowMapSize(shadows);
					Config.raw.rp_shadowmap_cube = getShadowMapSize(shadows);

					ui.text("");

					// FOV
					data.cam_fov = ui.slider(Id.handle({value: data.cam_fov}), "Camera FOV", MinimumFOV, MaximumFOV);
					// View Distance
					data.cam_viewdistance = ui.slider(Id.handle({value: data.cam_viewdistance}), "Camera View Distance", MinimumViewDistance, MaximumViewDistance);

					ui.text("");

					// Apply button
					ui.row([1/3, 1/3, 1/3]);
					if (ui.button("Apply")) {
						RenderPathCreator.applyConfig();
						Config.save();
						Storage.save();
					}
					ui.text("");
					// Close button
					if (ui.button("Close")) {
						state = 0;
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

	function getShadowQuality(i:Int):Int {
		// 0 - High, 1 - Medium, 2 - Low
		return i == 2048 ? 0 : i == 1024 ? 1 : 2;
	}

	function getShadowMapSize(i:Int):Int {
		// High - 2048, Medium - 1024, Low - 512
		return i == 0 ? 2048 : i == 1 ? 1024 : 512;
	}
}
