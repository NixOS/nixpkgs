{ mkDerivation }:
mkDerivation {
  path = "usr.bin/vtfontcvt";
  extraPaths = [ "sys/cddl/contrib/opensolaris/common/lz4" ];
}
