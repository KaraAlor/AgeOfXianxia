package arm.ui;

class MapEditorController extends iron.Trait {
	// UI
    var ui:Zui;
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
        ui.end();

        g.begin(false);
	}
}