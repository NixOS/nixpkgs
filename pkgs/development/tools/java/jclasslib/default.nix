{stdenv, fetchurl, xpf, j2re, ant}:

stdenv.mkDerivation {
  name = "jclasslib-2.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://belnet.dl.sourceforge.net/sourceforge/jclasslib/jclasslib_unix_2_0.tar.gz;
    md5 = "31d91bb03fee23410689d2f1c4c439b1";
  };

  inherit j2re xpf ant;
  buildInputs = [xpf ant];
}
