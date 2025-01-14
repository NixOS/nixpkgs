{ mkDerivation, libgeom }:
mkDerivation {
  path = "sbin/bsdlabel";
  extraPaths = [ "sys/geom" ];
  buildInputs = [ libgeom ];
}
