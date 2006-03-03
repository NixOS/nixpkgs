{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.2pre4979";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/patchelf-0.2pre4979/patchelf-0.2pre4979.tar.bz2;
    md5 = "d45a5a8e13fcef951556d351cc7a64a0";
  };
}
