{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "ed-0.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/ed-0.2.tar.gz;
    md5 = "ddd57463774cae9b50e70cd51221281b";
  };
}
