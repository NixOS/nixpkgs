source $stdenv/setup

export DESTDIR=$out

preInstall() {
  ensureDir $out
  ensureDir $out/etc
  ensureDir $out/sbin
  ensureDir $out/usr
  make install-program
}

genericBuild
