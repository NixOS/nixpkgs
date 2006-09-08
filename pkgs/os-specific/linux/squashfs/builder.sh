source $stdenv/setup

preBuild() {
  cd squashfs-tools
}

preBuild=preBuild

installPhase() {
  ensureDir $out/sbin
  cp mksquashfs $out/sbin
  cp unsquashfs $out/sbin
}

installPhase=installPhase

genericBuild
