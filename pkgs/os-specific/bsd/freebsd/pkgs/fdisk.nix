{ mkDerivation, libgeom }:
mkDerivation {
  path = "sbin/fdisk";

  buildInputs = [ libgeom ];
}
