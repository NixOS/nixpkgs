{ mkDerivation }:
mkDerivation {
  path = "usr.sbin/slaacctl";

  extraPaths = [ "sbin/slaacd" ];

}
