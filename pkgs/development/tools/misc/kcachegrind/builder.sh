source $stdenv/setup


export KDEDIR=$kdelibs

configureFlags="\
  --without-arts
  --x-includes=$libX11/include \
  --x-libraries=$libX11/lib \
  "

genericBuild
