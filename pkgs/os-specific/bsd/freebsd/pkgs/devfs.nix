{ mkDerivation }:
mkDerivation {
  path = "sbin/devfs";

  # These config files are mostly examples and not super useful
  # in nixbsd
  postPatch = ''
    sed -i 's/^CONFS=.*$//' $BSDSRCDIR/sbin/devfs/Makefile
  '';
}
