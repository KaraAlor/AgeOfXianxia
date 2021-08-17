#########################
#Main Server Makefile
#########################
MAIN = main.cpp
BUILD_DIR = build
RELEASE_DIR = bin
SCRIPTS_DIR = scripts
INCLUDE_DIR = include
SRC_DIR = src
NAME = aox

CCW32 = i686-w64-mingw32-g++
CCW64 = x86_64-w64-mingw32-g++
CCL = g++
CCM = g++
AL = $(BUILD_DIR)/lin/*.a
AM = $(BUILD_DIR)/mac/*.a
AW32 = $(BUILD_DIR)/w32/*.dll.a
AW64 = $(BUILD_DIR)/w64/*.dll.a
LIBSL = -L$(BUILD_DIR)/lin -lSDL2 -lGL -lX11 -ldl -lpthread -lrt
LIBSM =	-L$(BUILD_DIR)/mac -lSDL2 -lGL -lX11 -ldl -lpthread -lrt
LIBSW32 = -L/usr/lib/x86_64-linux-gnu/ -L$(BUILD_DIR)/w32 -lSDL2main -lSDL2 -lopengl32 -lX11 -ldl -lpthread -lrt -lbgfx-shared-libRelease
LIBSW64 = -L/usr/lib/x86_64-linux-gnu/ -L$(BUILD_DIR)/w64 -lSDL2main -lSDL2 -lopengl32 -lX11 -ldl -lpthread -lrt -lbgfx-shared-libRelease

CFLAGS = -w -g
CFLAGS_O = -w:-g:-c

VALGRIND_EXEC = valgrind --leak-check=full --show-leak-kinds=all
GDB_EXEC = gdb

define newline


endef

#Get OS and configure based on OS
ifeq ($(OS),Windows_NT)
    ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
        CFLAGS += -D AMD64
   		DISTRO = w64
   	else
	    ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
	        CFLAGS += -D AMD64
			DISTRO = w64
	    endif
	    ifeq ($(PROCESSOR_ARCHITECTURE),x86)
	        CFLAGS += -D IA32 WIN32
			DISTRO = w32
	    endif
    endif
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        CFLAGS += -D LINUX
   		DISTRO = lin
    endif
    ifeq ($(UNAME_S),Darwin)
        CFLAGS += -D OSX
   		DISTRO = mac
    endif
    ifeq ($(UNAME),Solaris)
   		DISTRO = sol
    endif
    UNAME_P := $(shell uname -p)
    ifeq ($(UNAME_P),x86_64)
        CFLAGS += -D AMD64
    endif
    ifneq ($(filter %86,$(UNAME_P)),)
        CFLAGS += -D IA32
    endif
    ifneq ($(filter arm%,$(UNAME_P)),)
        CFLAGS += -D ARM
    endif
endif

A =
CC = 
LIBS = 
EXT = -$(DISTRO)

.PHONY: main all help fix run valgrind gdb clean objects executable linux-var linux mac-var mav-var windows64 windows64-var windows32-var solaris solaris-var FORCE
#########################
#Assemble for distro
#########################
main: objects executable

objects:
	$(eval ifeq ($(DISTRO),w64) $(newline)\
		A = $(AW64) $(newline)\
		LIBS = $(LIBSW64) $(newline)\
		CC = $(CCW64) $(newline)\
		CFLAGS_O =$(CFLAGS_O):-I../../$(INCLUDE_DIR)$(newline)\
	endif $(newline)\
	ifeq ($(DISTRO),w32) $(newline)\
		A = $(AW32) $(newline)\
		LIBS = $(LIBSW32) $(newline)\
		CC = $(CCW32) $(newline)\
		CFLAGS_O =$(CFLAGS_O):-I../../$(INCLUDE_DIR)$(newline)\
	endif $(newline)\
	ifeq ($(DISTRO),lin) $(newline)\
		A = $(AL) $(newline)\
		LIBS = $(LIBSL) $(newline)\
		CC = $(CCL) $(newline)\
	endif $(newline)\
	ifeq ($(DISTRO),mac) $(newline)\
		A = $(AM) $(newline)\
		LIBS = $(LIBSM) $(newline)\
		CC = $(CCM) $(newline)\
	endif $(newline)\
	ifeq ($(DISTRO),sol) $(newline)\
		A = $(AL) $(newline)\
		LIBS = $(LIBSL) $(newline)\
		CC = $(CCL) $(newline)\
	endif)
	@echo -e making for `tput bold`$(DISTRO)`tput sgr0`... | awk '{sub(/-e /,""); print}'
	@echo -e '\t'Compiling object code... | awk '{sub(/-e /,""); print}'
	@mkdir -p $(BUILD_DIR)
	@cd $(BUILD_DIR)/$(DISTRO) && ../../$(SCRIPTS_DIR)/includes.sh ../../$(SRC_DIR)/$(MAIN) $(CC) $(CFLAGS_O)
	@echo -e '\t'Done Compiling | awk '{sub(/-e /,""); print}'
	@mkdir -p $(RELEASE_DIR)

executable:
	@echo -e $(NAME)$(EXT) "\n" $(BUILD_DIR) "\n" $(RELEASE_DIR) "\n" $(CC) "\n" $(CFLAGS) "\n" $(A) "\n" $(LIBS) "\n" $(DISTRO) "\n" | awk '{sub(/-e /,""); print}' > assemble.txt
	@$(SCRIPTS_DIR)/assemble.sh < assemble.txt
	@$(MAKE) -f assemble.mk --no-print-directory | grep -vE "(Nothing to be done for|is up to date)" || :
	@rm -f assemble.txt 2>/dev/null || :
	@rm -f assemble.mk 2>/dev/null || :

linux: linux-var main

linux-var:
	$(eval DISTRO = lin)

mac: mac-var main

mac-var:
	$(eval DISTRO = mac)

solaris: solaris-var main

solaris-var:
	$(eval DISTRO = sol)

windows32: windows32-var main

windows32-var:
	$(eval DISTRO = w32)

windows64: windows64-var main

windows64-var:
	$(eval DISTRO = w64)

all:
	@$(MAKE) linux --no-print-directory
	@$(MAKE) mac --no-print-directory
	@$(MAKE) solaris --no-print-directory
	@$(MAKE) windows32 --no-print-directory
	@$(MAKE) windows64 --no-print-directory

#########################
#Utility functions
#########################
help:
	@echo -e "Available build targets:\
\n\t`tput bold`Command;Description`tput sgr0`\
\n\tmain;Build for detected operating system\
\n\tobjects;Build only objects for detected operating system\
\n\texecutable;Build only executable for detected operating system\
\n\tlinux;Build for linux\
\n\tmac;Build for mac\
\n\tsolaris;Build for solaris\
\n\twindows32;Build for Windows 32 bit\
\n\twindows64;Build for windows 64 bit\
\n\trun;Run for detected operating system\
\n\tvalgrind;Run with valgrind for detecting memory leaks\
\n\tgdb;Run with GDB for debugging purposes\
\n\tclean;Remove build directories and release executable\
\n\tfix;Replaces spaces with tabs in source files\
\n\thelp;Print availabe commands" | awk '{sub(/-e /,""); print}' | column -t -s ';'

run: main
	@cd ./$(RELEASE_DIR) && ./$(NAME)$(EXT)

valgrind: main
	@cd ./$(RELEASE_DIR) && $(VALGRIND_EXEC) ./$(NAME)

gdb: main
	@cd ./$(RELEASE_DIR) && $(GDB_EXEC) ./$(NAME)

clean:
	@echo Cleaning... | awk '{sub(/-e /,""); print}'
	@rm -f $(BUILD_DIR)/*/*.o 2>/dev/null || :
	@rm -f $(RELEASE_DIR)/$(NAME)* 2>/dev/null || :
	@echo Done cleaning | awk '{sub(/-e /,""); print}'

fix:
	@echo Replacing spaces with tabs in source files | awk '{sub(/-e /,""); print}'
	@./scripts/fix.sh src
#EOF
