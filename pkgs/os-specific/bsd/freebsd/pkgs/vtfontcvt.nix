{ mkDerivation }:
mkDerivation {
  path = "usr.bin/vtfontcvt";
  extraPaths = [ "sys/cddl/contrib/opensolaris/common/lz4" ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-unterminated-string-initialization"
  ];
}
