{ mkDerivation, mknod }:

mkDerivation {
  path = "usr.sbin/mtree";
  version = "9.2";
  sha256 = "04p7w540vz9npvyb8g8hcf2xa05phn1y88hsyrcz3vwanvpc0yv9";
  extraPaths = [ mknod.src ];
}
