{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.1pre3994";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/patchelf-0.1pre3994/patchelf-0.1pre3994.tar.gz;
    md5 = "26d335b0b1c335c19b1a1b36d1002e09";
  };
}
