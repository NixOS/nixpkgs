{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "udev-091";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/udev-091.tar.bz2;
    md5 = "4151022ea7b4dcfaa768c1b7bf2ab9e5";
  };
  patches = [./udev-091-installpath.patch];
}
