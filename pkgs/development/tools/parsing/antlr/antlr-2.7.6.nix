{stdenv, fetchurl, jdk, python}:

stdenv.mkDerivation {
  name = "antlr-2.7.6";
  src = fetchurl {
    url = http://www.antlr.org/download/antlr-2.7.6.tar.gz;
    md5 = "17d8bf2e814f0a26631aadbbda8d7324";
  };
  buildInputs = [jdk python];
}
