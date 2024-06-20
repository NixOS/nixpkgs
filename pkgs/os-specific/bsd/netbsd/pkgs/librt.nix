{
  lib,
  mkDerivation,
  libc,
  headers,
}:

mkDerivation {
  path = "lib/librt";
  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ libc.path ] ++ libc.extraPaths;
  postPatch = ''
    sed -i 's,/usr\(/include/sys/syscall.h\),${headers}\1,g' \
      $BSDSRCDIR/lib/{libc,librt}/sys/Makefile.inc
  '';
}
