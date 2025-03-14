$src/libexec/ld-elf.so.1 $src/bin/mkdir $out
$src/libexec/ld-elf.so.1 $src/bin/tar -I "$src/libexec/ld-elf.so.1 $src/bin/xz" -C $out -xf $bootstrapTools
export LD_LIBRARY_PATH=$out/lib

BADLIST=ld-elf.so.1

oobpatch() {
    $out/libexec/ld-elf.so.1 $src/bin/cp $1 ./tmp
    $out/libexec/ld-elf.so.1 $out/bin/patchelf --set-rpath $out/lib --set-interpreter $out/libexec/ld-elf.so.1 ./tmp
    $out/libexec/ld-elf.so.1 $src/bin/mv ./tmp $1
    BADLIST="$BADLIST|${1##*/}"
}

oobpatch $out/bin/patchelf
oobpatch $out/lib/libthr.so.3
oobpatch $out/lib/libc.so.7

for f in $($out/libexec/ld-elf.so.1 $out/bin/find $out/lib -type f); do
    $out/libexec/ld-elf.so.1 $out/bin/grep -E "$BADLIST" <<<"$f" && continue
    $out/libexec/ld-elf.so.1 $out/bin/patchelf --set-rpath $out/lib $f
done
for f in $out/bin/* $out/bin/.*; do
    $out/libexec/ld-elf.so.1 $out/bin/grep -E "$BADLIST" <<<"$f" &>/dev/null && continue
    $out/libexec/ld-elf.so.1 $out/bin/patchelf --set-rpath $out/lib --set-interpreter $out/libexec/ld-elf.so.1 $f
done

unset LD_LIBRARY_PATH
export PATH=$out/bin

# sanity check
$out/bin/true || exit 1

# meticulously replace every nix store path with the right one
# to work with binaries, make sure the path remains the same length by prefixing pathsep chars
for f in $(find $out -type f); do
    while true; do
        BADMAN="$(strings $f | grep -o '/nix/store/.*' | grep -v "$out" | head -n1)"
        if [ -z "$BADMAN" ]; then
            break
        fi
        echo scorch $f
        BADMAN="$(echo "$BADMAN" | cut -d/ -f-4)"
        GOODMAN="$out"
        if [ ${#GOODMAN} -gt ${#BADMAN} ]; then
            echo "Can't patch $f: $BADMAN too short"
            break
        fi
        while ! [ ${#GOODMAN} -eq ${#BADMAN} ]; do
            GOODMAN="/$GOODMAN"
        done
        if ! sed -E -i -e "s@$BADMAN@$GOODMAN@g" $f; then
            echo "Can't patch $f: sed failed"
            break
        fi
    done
done
echo $out
