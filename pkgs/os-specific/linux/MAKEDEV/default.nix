{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "MAKEDEV-3.23.1";
  src = fetchurl {
    url = http://losser.labs.cs.uu.nl/~armijn/.nix/MAKEDEV-3.23-1.tar.gz;
    md5 = "554faf6cbc9a84e4bd58ccfa32d74e2f";
  };
  patches = [./MAKEDEV-install.patch];
}
