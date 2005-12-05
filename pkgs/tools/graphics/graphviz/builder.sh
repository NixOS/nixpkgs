source $stdenv/setup

configureFlags="\
    --with-pngincludedir=$libpng/include \
    --with-pnglibdir=$libpng/lib \
    --with-jpegincludedir=$libjpeg/include \
    --with-jpeglibdir=$libjpeg/lib \
    --with-expatincludedir=$expat/include \
    --with-expatlibdir=$expat/lib \
    "

genericBuild