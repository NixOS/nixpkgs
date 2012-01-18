source $stdenv/setup

# This is a very dirty hack to prevent the binaries from putting the
# Mesa libraries in their RPATHs.
mkdir -p $out/tmp
ln -s $mesa/lib/* $out/tmp/
mkdir -p $out/lib
ln -s $mesa/lib/libGLU* $out/lib/
export NIX_LDFLAGS="-L$out/tmp $NIX_LDFLAGS"

genericBuild

rm -rf $out/tmp


# Add a wrapper around each program to use the appropriate OpenGL driver.
mkdir -p $out/bin/.orig

for i in $(cd $out/bin && ls); do
    mv $out/bin/$i $out/bin/.orig/$i
    cat >$out/bin/$i <<EOF
#! $SHELL -e

mesa=$mesa

$(cat $mesaSwitch)

exec $out/bin/.orig/$i "\$@"
EOF
    chmod +x $out/bin/$i
done
