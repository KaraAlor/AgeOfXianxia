# AgeOfXianxia
## About
New game project for mix of xianxia and asatru lore.  Development is still very early and all features / design goals are subject to change.

## Prerequisites
Releases come bundled with all the DLLs needed to execute the program.

## Prerequisites (Building)
This project is built inside a docker so all you need to run this is to create our docker image.
Docker build config can be found [here.](https://raw.githubusercontent.com/Kyrasuum/Configs/main/dev_docker.txt)

## Building
There is a makefile within the root directory of the project, simple execute 'make' to build the project for your OS.

## Design Goals
    * RPG mechanics
    * 3D graphics
    * basic animatinos
    * multiple camera styles
    * multiplayer
as always, development is early so all goals are subject to changes.

## Supported Operating Systems
Currently we have release targets for:
	* Linux
	* Windows (32 and 64 bit)

As of writing BGFX is capable of building for the following and therefore possible to build this project for aswell.
    * android-arm-release
    * android-arm64-release
    * android-x86-release
    * wasm2js-release
    * wasm-release
    * linux-release64
    * freebsd-release32
    * freebsd-release64
    * mingw-gcc-release32
    * mingw-gcc-release64
    * mingw-clang-release32
    * mingw-clang-release64
    * vs2017-release32
    * vs2017-release64
    * vs2017-winstore100-release32
    * vs2017-winstore100-release64
    * osx-release
    * osx-x64-release
    * osx-arm64-release
    * ios-arm-release
    * ios-arm64-release
    * ios-simulator-release
    * ios-simulator64-release
    * rpi-release
## Acknowledgements
This project utilizes the BGFX rendering engine and therefore we also include any acknowledgements of theirs.

## Versioning
Releases will be versioned and packed into a zip for convenience each release will be incremental in verison number.

## License
This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details

## Team
Currently we are a small team of two developers

## Contact Us
You can contact us via email at plorentz7@gmail.com
