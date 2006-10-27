source $stdenv/setup

skip=7976

bunzip2 < $src | (dd bs=1 count=$skip of=/dev/null && dd bs=1M) | tar xvf - ut2004demo.tar

mkdir $out

(cd $out && tar xvf -) < ut2004demo.tar


# Patch the executable from ELF OS/ABI type `Linux' (3) to `SVR4' (0).
# This doesn't seem to matter to ld-linux.so.2 at all, except that it
# refuses to load `Linux' executables when invokes explicitly, that
# is, when we do `ld-linux.so.2 $out/System/ut2004-bin', which we need
# to override the hardcoded ELF interpreter with our own.

# This is a horrible hack, of course.  A better solution would be to
# patch Glibc so it accepts the `Linux' ELF type as well (why doesn't
# it?); or to use FreeBSD's `brandelf' program to set to ELF type
# (which is a bit cleaner than patching using `dd' :-) ).

#(cd $out/System && (echo -en "\000" | dd bs=1 seek=7 of=ut2004-bin conv=notrunc))


# Set the ELF interpreter to our own Glibc.
for i in "$out/System/ucc-bin" "$out/System/ut2004-bin"; do
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" "$i"
done
