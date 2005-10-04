{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.1pre4005";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/patchelf-0.1pre4005/patchelf-0.1pre4005.tar.gz;
    md5 = "95f0a2025d72a8499d608cc706c097b3";
  };
}
