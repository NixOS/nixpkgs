{ mkDerivation }:
mkDerivation {
  path = "usr.sbin/dhcpleasectl";

  extraPaths = [ "sbin/dhcpleased" ];

}
