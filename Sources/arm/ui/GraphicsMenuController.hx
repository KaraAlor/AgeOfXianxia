package arm.ui;

import zui.*;
import iron.App;

import arm.DataConfig;
import armory.data.Config;
import iron.system.Storage;
import armory.renderpath.RenderPathCreator;

class GraphicsMenuController extends iron.Trait {
	// Retrieve storage
	static var data: DataConfig = Storage.data.config;
	// UI
    var ui: Zui;
    public var visible: Bool = false;
	
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
            if (ui.tab(Id.handle({selected: true}), "Graphics")) {
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
                data.cam_fov = ui.slider(Id.handle({value: data.cam_fov}), "Camera FOV", DataConfig.Global.MinimumFOV, DataConfig.Global.MaximumFOV);
                // View Distance
                data.cam_viewdistance = ui.slider(Id.handle({value: data.cam_viewdistance}), "Camera View Distance", DataConfig.Global.MinimumViewDistance, DataConfig.Global.MaximumViewDistance);

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
                    visible = false;
                }
                
                ui.unindent();
            }
        }
        ui.end();

        g.begin(false);
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
