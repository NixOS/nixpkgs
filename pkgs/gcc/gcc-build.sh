#! /bin/sh

. $stdenv/setup || exit 1
export PATH=$binutils/bin:$PATH

tar xvfj $src || exit 1

# Disable the standard include directories.
cd gcc-* || exit 1
cat >> ./gcc/cppdefault.h <<EOF
#undef LOCAL_INCLUDE_DIR
#undef SYSTEM_INCLUDE_DIR
#undef STANDARD_INCLUDE_DIR
EOF
cd .. || exit 1

# Configure.
mkdir build || exit 1
cd build || exit 1
../gcc-*/configure --prefix=$out --enable-languages=c,c++ || exit 1

# Patch some of the makefiles to force linking against our own glibc.
extraflags="-Wl,-s -isystem $linux/include $NIX_CFLAGS_COMPILE $NIX_CFLAGS_LINK"
for i in $NIX_LDFLAGS; do
    extraflags="$extraflags -Wl,$i"
done

mf=Makefile
sed \
 -e "s^FLAGS_FOR_TARGET =\(.*\)^FLAGS_FOR_TARGET = \1 $extraflags^" \
 < $mf > $mf.tmp || exit 1
mv $mf.tmp $mf

mf=gcc/Makefile
sed \
 -e "s^X_CFLAGS =\(.*\)^X_CFLAGS = \1 $extraflags^" \
 < $mf > $mf.tmp || exit 1
mv $mf.tmp $mf

# Patch gcc/Makefile to prevent fixinc.sh from "fixing" system header files
# from /usr/include.
mf=gcc/Makefile
sed \
 -e "s^NATIVE_SYSTEM_HEADER_DIR =\(.*\)^NATIVE_SYSTEM_HEADER_DIR = /fixinc-disabled^" \
 < $mf > $mf.tmp || exit 1
mv $mf.tmp $mf

# Build and install.
make bootstrap || exit 1
make install || exit 1
