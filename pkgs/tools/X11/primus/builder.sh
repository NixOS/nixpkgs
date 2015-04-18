source $stdenv/setup

cp -r $src src
cd src

export LIBDIR=$out/lib
export PRIMUS_libGLa=$nvidia/lib/libGL.so
export PRIMUS_libGLd=$mesa/lib/libGL.so
export PRIMUS_LOAD_GLOBAL=$mesa/lib/libglapi.so

make
ln -s $LIBDIR/libGL.so.1 $LIBDIR/libGL.so
