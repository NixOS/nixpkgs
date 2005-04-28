. $stdenv/setup

postUnpack=postUnpack
postUnpack() {
    ensureDir $out/share/texmf
    ensureDir $out/share/texmf-dist
    gunzip < $texmf | (cd $out/share/texmf-dist && tar xvf -)
}

configureFlags="\
  --disable-multiplatform \
  --without-x11 \
  --without-xdvik \
  --without-oxdvik \
  --with-system-zlib \
  --with-system-pnglib \
  --with-system-ncurses \
  "

genericBuild
