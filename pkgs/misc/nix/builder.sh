. $stdenv/setup

configureFlags="\
  --with-store-dir=$storeDir --localstatedir=$stateDir \
  --with-aterm=$aterm --with-bdb=$bdb"

genericBuild
