source $stdenv/setup

installPhase() {
   make install
   # oh this is fugly and should actually be fixed in e2fsprogs
   ensureDir $out/man/man3
   make -C lib/blkid install
   make -C lib/e2p install
   make -C lib/et install
   make -C lib/ext2fs install
   make -C lib/ss install
   make -C lib/uuid install
}

installPhase=installPhase

genericBuild
