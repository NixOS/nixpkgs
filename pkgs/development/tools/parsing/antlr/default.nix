{stdenv, fetchurl, jre}:

stdenv.mkDerivation {
  name = "antlr-3.0b3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/antlr-3.0b3.tar.gz;
    md5 = "6a7e70ccece8149b735cc3aaa24241cc";
  };
  inherit jre;
}
