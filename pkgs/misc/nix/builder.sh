. $stdenv/setup

configureFlags="\
  --with-store-dir=/nix/store --localstatedir=/nix/var \
  --with-aterm=$aterm --with-bdb=$bdb"

genericBuild
