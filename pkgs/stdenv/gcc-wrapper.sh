#! /bin/sh

IFS=

realgcc=@GCC@
libc=@LIBC@

justcompile=0
for i in $@; do
    if test "$i" == "-c"; then
        justcompile=1
    fi
done

extra=("-isystem" "$libc/include")
if test "$justcompile" != "1"; then
    extra=(${extra[@]} "-L" "$libc/lib" "-Wl,-dynamic-linker,$libc/lib/ld-linux.so.2,-rpath,$libc/lib")
fi

exec $realgcc $@ ${extra[@]}
