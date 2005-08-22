{stdenv, fetchurl, ocaml}: stdenv.mkDerivation {
  name = "hevea-1.07";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/hevea-1.07.tar.gz;
    md5 = "561d7a2c10ea9e6a5b352c24d9b65998";
  };
  buildInputs = [ocaml];
}
