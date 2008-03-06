source $stdenv/setup

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
  --without-texinfo \
  --without-texi2html \
  --with-system-zlib \
  --with-system-pnglib \
  --with-system-ncurses \
  "

postInstall() {
    ensureDir "$out/nix-support"
    cp $setupHook $out/nix-support/setup-hook
}
postInstall=postInstall

genericBuild
