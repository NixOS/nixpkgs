source $stdenv/setup

cp -r $src src
cd src

export LIBDIR=$out/x86_64
export PRIMUS_libGLa=$nvidia/lib/libGL.so
export PRIMUS_libGLd=/var/run/opengl-driver/lib/libGL.so
export PRIMUS_LOAD_GLOBAL=/var/run/opengl-driver/lib/libglapi.so

make
ln -s $out/x86_64/libGL.so.1 $out/x86_64/libGL.so
