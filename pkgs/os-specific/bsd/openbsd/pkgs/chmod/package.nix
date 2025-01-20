{ mkDerivation }:
mkDerivation {
  path = "bin/chmod";

  patches = [ ./no-sbin.patch ];
}
