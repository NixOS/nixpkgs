{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/patchelf-0.1/patchelf-0.1.tar.bz2;
    md5 = "bc20c173bf8bd590fa8ee0f348a563be";
  };
}
