{stdenv, fetchurl, xpf, jre, ant}:

stdenv.mkDerivation {
  name = "jclasslib-2.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/jclasslib/jclasslib_unix_2_0.tar.gz;
    md5 = "31d91bb03fee23410689d2f1c4c439b1";
  };

  inherit jre xpf ant;
  buildInputs = [xpf ant];
}
