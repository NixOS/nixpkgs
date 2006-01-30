{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "udev-068";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/udev-068.tar.bz2;
    md5 = "fd9db7375dae81e8aa634414b5ede0d6";
  };
  patches = [./udev-installpath.patch];
}
