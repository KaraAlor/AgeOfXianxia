#########################
#Main Makefile
#########################
MAIN = Main
BUILD_DIR = build
RELEASE_DIR = bin
SRC_DIR = src
NAME = aox

CC = node kha/make --compile
VALGRIND_EXEC = valgrind --leak-check=full --show-leak-kinds=all

define newline


endef

# attempt to detect host os
ifeq ($(OS),Windows_NT)
    ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
   		DISTRO = windows
   	else
	    ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
			DISTRO = windows
	    endif
	    ifeq ($(PROCESSOR_ARCHITECTURE),x86)
			DISTRO = windows
	    endif
    endif
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
   		DISTRO = linux
    endif
    ifeq ($(UNAME_S),Darwin)
   		DISTRO = osx
    endif
    ifeq ($(UNAME),Solaris)
   		DISTRO = linux
    endif
    UNAME_P := $(shell uname -p)
    ifeq ($(UNAME_P),x86_64)
        # CFLAGS += -D AMD64
    endif
    ifneq ($(filter %86,$(UNAME_P)),)
        # CFLAGS += -D IA32
    endif
    ifneq ($(filter arm%,$(UNAME_P)),)
        # CFLAGS += -D ARM
    endif
endif

EXT = -$(DISTRO)

.PHONY: main all help fix run clean objects setup \
linux linux-var \
windows windows-var \
html5 html5-var \
ios ios-var \
android android-var

#########################
#OS independent building
#########################
main: objects

setup:
	@echo -e making for `tput bold`$(DISTRO)`tput sgr0`... | awk '{sub(/-e /,""); print}'

objects: setup
	@mkdir -p $(BUILD_DIR)/$(DISTRO)
	@$(CC) $(DISTRO)
	@mkdir -p $(RELEASE_DIR)/$(DISTRO)
	@cp $(BUILD_DIR)/$(DISTRO)/* $(RELEASE_DIR)/$(DISTRO)/
	@mv $(RELEASE_DIR)/$(DISTRO)/$(NAME) $(RELEASE_DIR)/$(DISTRO)/$(NAME)$(EXT)


#########################
#Specific OS building
#########################
linux: linux-var main

linux-var:
	$(eval DISTRO = linux)

windows: windows-var main

windows-var:
	$(eval DISTRO = windows)

android: android-var main

android-var:
	$(eval DISTRO = android)

ios: ios-var main

ios-var:
	$(eval DISTRO = ios)

html5: html5-var main

html5-var:
	$(eval DISTRO = html5)

all:
	@$(MAKE) linux --no-print-directory
	@$(MAKE) windows --no-print-directory
	@$(MAKE) android --no-print-directory
	@$(MAKE) ios --no-print-directory
	@$(MAKE) html5 --no-print-directory

#########################
#Utility functions
#########################
help:
	@echo -e "Available build targets:\
\n\t`tput bold`Command;Description`tput sgr0`\
\n\tmain;Build for detected operating system\
\n\tall;Build for all currently supported operating systems\
\n\tobjects;Build only objects for detected operating system\
\n\texecutable;Build only executable for detected operating system\
\n\tlinux;Build for linux\
\n\twindows;Build for Windows 32 bit\
\n\tandroid;Build for android\
\n\tios;Build for ios\
\n\thtml5;Build for web\
\n\trun;Run for detected operating system\
\n\tvalgrind;Run with valgrind for detecting memory leaks\
\n\tgdb;Run with GDB for debugging purposes\
\n\tclean;Remove build directories and release executable\
\n\tfix;Replaces spaces with tabs in source files\
\n\thelp;Print availabe commands" | awk '{sub(/-e /,""); print}' | column -t -s ';'

run: main
	@cd ./$(RELEASE_DIR)/$(DISTRO) && ./$(NAME)$(EXT)

valgrind: main
	@cd ./$(RELEASE_DIR)/$(DISTRO) && $(VALGRIND_EXEC) ./$(NAME)$(EXT)

clean:
	@echo Cleaning... | awk '{sub(/-e /,""); print}'
	@rm -rf $(BUILD_DIR) 2>/dev/null || :
	@rm -rf $(RELEASE_DIR) 2>/dev/null || :
	@echo Done cleaning | awk '{sub(/-e /,""); print}'

fix:
	@echo Replacing spaces with tabs in source files | awk '{sub(/-e /,""); print}'
	@./scripts/fix.sh src
#EOF
