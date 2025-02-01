{
  lib,
  mkDerivation,
  libc,
  headers,
}:

mkDerivation {
  path = "lib/librt";
  version = "9.2";
  sha256 = "07f8mpjcqh5kig5z5sp97fg55mc4dz6aa1x5g01nv2pvbmqczxc6";
  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ libc.src ] ++ libc.extraPaths;
  postPatch = ''
    sed -i 's,/usr\(/include/sys/syscall.h\),${headers}\1,g' \
      $BSDSRCDIR/lib/{libc,librt}/sys/Makefile.inc
  '';
}
