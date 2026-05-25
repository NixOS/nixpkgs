{ mkDerivation, libufs }:
mkDerivation {
  path = "sbin/newfs";
  extraPaths = [ "sys/geom" ];
  buildInputs = [ libufs ];
}
