{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.3pre7826";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/patchelf-0.3pre7826/patchelf-0.3pre7826.tar.bz2;
    sha256 = "0wnb5a5964dgp55awygvzw2ssa6j63s568qg4i6kjfx11vvl3zqi";
  };
}
