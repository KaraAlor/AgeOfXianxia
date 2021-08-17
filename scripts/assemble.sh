#!/bin/bash
count=-1
name=""
build_dir=""
release_dir=""
cc=""
cflags=""
a=""
libs=""
distro=""
while IFS= read -r line; do
	count=$( expr $count + 1 )
	case $count in
		(0) name=${line::-1};;
		(1)	build_dir=${line::-1};;
		(2) release_dir=${line::-1};;
		(3) cc=${line::-1};;
		(4) cflags=${line::-1};;
		(5) a=${line::-1};;
		(6) libs=${line::-1};;
		(7) distro=${line::-1};;
	esac
done

read -r -d '' MAKE <<EOF
name=$name
build_dir=$build_dir
release_dir=$release_dir
cc=$cc
cflags=$cflags
a=$a
libs=$libs
distro=$distro

.PHONY: main premain

main: premain \$(release_dir)/\$(name)
	@echo -e '\t'Done Assembling | awk '{sub(/-e /,""); print}'

premain:
	@echo -e '\t'Assembling executable... | awk '{sub(/-e /,""); print}'

\$(release_dir)/\$(name): \$(build_dir)/\$(distro)/*.o
	@mkdir -p \$(release_dir) 2>/dev/null || :
	@echo -e '\t\t'Executable is being assembled... | awk '{sub(/-e /,""); print}'
	@\$(cc) \$(cflags) \$^ \$(a) -o \$@ \$(libs)
EOF
echo "$MAKE" > assemble.mk
