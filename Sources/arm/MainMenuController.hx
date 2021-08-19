package arm;

import iron.Scene;
import armory.trait.internal.CanvasScript;
import armory.system.Event;

class MainMenuController extends iron.Trait {
	static var main_canvas:CanvasScript;
	var menu_state = 0;
	public function new() {
		super();

        notifyOnInit(init);
        // notifyOnUpdate();
		// notifyOnRemove();
	}

	function init() {
		main_canvas = Scene.active.getTrait(CanvasScript);
        if (main_canvas != null){
			var menu_bar = main_canvas.getElement("MenuBar");

			if (menu_bar != null){
				menu_bar.visible = true;
				Event.add("startgame_btn", function(){
					main_canvas.getElement("MenuBar").visible = false;
					Scene.setActive("GameSpace");
				});
				Event.add("settings_btn", function(){
				});
				Event.add("quit_btn", function(){
				});
			};
		};
	}
}
