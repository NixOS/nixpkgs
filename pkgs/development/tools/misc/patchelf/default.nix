{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.1pre1514";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/nix/patchelf-0.1pre1514/patchelf-0.1pre1514.tar.gz;
    md5 = "b3d82ce1dc68304770fe5411ed718e3a";
  };
#  src = /home/eelco/Dev/patchelf/patchelf-0.1.tar.gz;
}
