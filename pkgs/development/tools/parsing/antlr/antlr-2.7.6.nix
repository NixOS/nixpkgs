{stdenv, fetchurl, jre}:

stdenv.mkDerivation {
  name = "antlr-2.7.6";
  builder = ./builder2.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/antlr-2.7.6.tar.gz;
    md5 = "17d8bf2e814f0a26631aadbbda8d7324";
  };
  inherit jre;
}
