BUILD_DIR = ./build/

.PHONY: prereq all compile compile-debug package clean hl-dx hl-dx-debug hl-sdl hl-sdl-debug js js-debug swf swf-debug

all: compile package

compile: $(BUILD_DIR)hl-dx $(BUILD_DIR)hl-sdl $(BUILD_DIR)js $(BUILD_DIR)swf

compile-debug: $(BUILD_DIR)hl-dx-debug $(BUILD_DIR)hl-sdl-debug $(BUILD_DIR)js-debug $(BUILD_DIR)swf-debug

package: hl-dx hl-sdl js swf

clean:
	@rm -rf bin

$(BUILD_DIR)hl-dx:
	@haxe $@.hxml

hl-dx: $(BUILD_DIR)hl-dx
	@echo haxelib run redistHelper -hl32 -zip -pak -o release/$@ -p $@ $(BUILD_DIR)$@.hxml

$(BUILD_DIR)hl-dx-debug:
	@haxe $@.hxml

hl-dx-debug: $(BUILD_DIR)hl-dx-debug
	@haxelib run redistHelper -hl32 -zip -pak -o release/$@ -p $@ $(BUILD_DIR)$@.hxml

$(BUILD_DIR)hl-sdl:
	@haxe $@.hxml

hl-sdl: $(BUILD_DIR)hl-sdl
	@haxelib run redistHelper -hl32 -zip -pak -o release/$@ -p $@ $(BUILD_DIR)$@.hxml

$(BUILD_DIR)hl-sdl-debug:
	@haxe $@.hxml

hl-sdl-debug: $(BUILD_DIR)hl-sdl-debug
	@haxelib run redistHelper -hl32 -zip -pak -o release/$@ -p $@ $(BUILD_DIR)$@.hxml

$(BUILD_DIR)js:
	@haxe $@.hxml

js: $(BUILD_DIR)js
	@haxelib run redistHelper -hl32 -zip -pak -o release/$@ -p $@ $(BUILD_DIR)$@.hxml

$(BUILD_DIR)js-debug:
	@haxe $@.hxml

js-debug: $(BUILD_DIR)js-debug
	@haxelib run redistHelper -hl32 -zip -pak -o release/$@ -p $@ $(BUILD_DIR)$@.hxml

$(BUILD_DIR)swf:
	@haxe $@.hxml

swf: $(BUILD_DIR)swf
	@haxelib run redistHelper -hl32 -zip -pak -o release/$@ -p $@ $(BUILD_DIR)$@.hxml

$(BUILD_DIR)swf-debug:
	@haxe $@.hxml

swf-debug: $(BUILD_DIR)swf-debug
	@haxelib run redistHelper -hl32 -zip -pak -o release/$@ -p $@ $(BUILD_DIR)$@.hxml

setup:
	@sudo add-apt-repository ppa:haxe/releases -y
	@sudo apt-get update
	@sudo apt-get install libglu1-mesa-dev freeglut3-dev mesa-common-dev libsdl2-2.0-0 libsdl2-dev -y
	@sudo apt-get install haxe -y
	@mkdir -p ~/haxelib && haxelib setup ~/haxelib
	@sudo apt-get install libpng-dev libturbojpeg-dev libvorbis-dev libopenal-dev libsdl2-dev libmbedtls-dev libuv1-dev -y
	@haxelib install hashlink
	@haxelib install hxcpp-debug-server
	@haxelib install heaps
	@haxelib install castle
	@haxelib install hxbit
	@haxelib install hscript
	@haxelib install hxnodejs
	@haxelib install format
	@haxelib install domkit
	@haxelib install hx3compat
	@haxelib install hide
	@haxelib install haxeui-core
	@haxelib install haxeui-heaps
	@haxelib install hlopenal
	@haxelib install hlsdl
	@haxelib install hldx
	@haxelib install vshaxe
	@haxelib install vscode
	@haxelib install vscode-debugadapter
	@haxelib install hscript
	@haxelib install redistHelper
	@git clone https://github.com/HaxeFoundation/hashlink.git ~/hashlink
	@cd ~/hashlink
	@sudo make && sudo make install
	@sudo mv /usr/local/lib/*.hdll /usr/lib/ 2>/dev/null || true
