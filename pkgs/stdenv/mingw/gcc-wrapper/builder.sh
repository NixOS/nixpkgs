source $STDENV/setup
source $SUBSTITUTE

if test -z "$out"; then
  out="$OUT"
  shell="$SHELL"
  gcc="$GCC"
  binutils="$BINUTILS"
fi

# Force gcc to use ld-wrapper.sh when calling ld.
# cflagsCompile="-B $OUT/bin/"

# The "-B$glibc/lib/" flag is a quick hack to force gcc to link
# against the crt1.o from our own glibc, rather than the one in
# /usr/lib.  The real solution is of course to prevent those paths
# from being used by gcc in the first place.
# The dynamic linker is passed in `ldflagsBefore' to allow
# explicit overrides of the dynamic linker by callers to gcc/ld
# (the *last* value counts, so ours should come first).
# cflagsCompile="$cflagsCompile -B $MINGWRUNTIME/lib/ -B $W32API/lib/ -isystem $MINGWRUNTIME/include -isystem $W32API/include"
# ldflags="$ldflags -L$MINGWRUNTIME/lib -L$W32API"
# ldflagsBefore="-dynamic-linker $glibc/lib/ld-linux.so.2"  Martin: no idea what to do with this on mingw.


ldflags="$ldflags -L$gcc/lib"
gccPath="$gcc/bin"
ldPath="$BINUTILS/bin"

mkdir $out
mkdir $out/bin
mkdir $out/nix-support

doSubstitute() {
    local src=$1
    local dst=$2
    substitute "$src" "$dst" \
        --subst-var "out" \
        --subst-var "shell" \
        --subst-var "gcc" \
        --subst-var "gccProg" \
        --subst-var "binutils" \
        --subst-var "cflagsCompile" \
        --subst-var "cflagsLink" \
        --subst-var "ldflags" \
        --subst-var "ldflagsBefore" \
        --subst-var-by "ld" "$ldPath/ld"
}


# Make wrapper scripts around gcc, g++, and g77.  Also make symlinks
# cc, c++, and f77.
mkGccWrapper() {
    local dst=$1
    local src=$2

    if ! test -f "$src"; then
        echo "$src does not exist (skipping)"
        return
    fi

    gccProg="$src"
    doSubstitute "$GCCWRAPPER" "$dst"
    chmod +x "$dst"
}

echo "gccpath: $gccPath"
mkGccWrapper $out/bin/gcc $gccPath/gcc.exe
ln -s $out/bin/gcc $out/bin/cc

# mkGccWrapper $out/bin/g++ $gccPath/g++.exe
# ln -s $out/bin/g++ $out/bin/c++

# mkGccWrapper $out/bin/g77 $gccPath/g77.exe
# ln -s $out/bin/g77 $out/bin/f77

# Make a wrapper around the linker.
doSubstitute "$LDWRAPPER" "$out/bin/ld"
chmod +x "$out/bin/ld"


# Emit a setup hook.  Also store the path to the original GCC and
# Glibc.
test -n "$GCC" && echo $GCC > $out/nix-support/orig-gcc
# test -n "$glibc" && echo $glibc > $out/nix-support/orig-glibc

doSubstitute "$ADDFLAGS" "$out/nix-support/add-flags"

doSubstitute "$SETUPHOOK" "$out/nix-support/setup-hook"

cp -p $UTILS $out/nix-support/utils
