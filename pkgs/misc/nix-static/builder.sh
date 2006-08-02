source $stdenv/setup

configureFlags="\
  --with-store-dir=$storeDir --localstatedir=$stateDir \
  --with-aterm=$aterm --with-bdb=$bdb \
  --disable-init-state"

preConfigure() {
  autoreconf
}

preConfigure=preConfigure

postInstall() {
  cd $out/bin

  find . -type f | while read fn; do
    cat $fn | sed "s|/nix/store/[a-z0-9]*-|/nix/store/ffffffffffffffffffffffffffffffff-|g" > $fn.tmp
    if test -x $fn; then chmod +x $fn.tmp; fi
    mv $fn.tmp $fn
  done
}

postInstall=postInstall

genericBuild
