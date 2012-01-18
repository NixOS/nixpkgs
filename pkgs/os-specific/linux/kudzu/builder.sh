source $stdenv/setup

export DESTDIR=$out

preInstall() {
  mkdir -p $out
  mkdir -p $out/etc
  mkdir -p $out/sbin
  mkdir -p $out/usr
  make install-program
}

genericBuild
