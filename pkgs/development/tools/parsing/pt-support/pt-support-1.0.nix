{stdenv, fetchurl, aterm, toolbuslib}: 

stdenv.mkDerivation {
  name = "pt-support-1.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/pt-support-1.0.tar.gz;
    md5 = "cc96dc2bfbaf3f218dfe9a0b8bb4d801";
  };
  inherit aterm toolbuslib;
  buildInputs = [aterm toolbuslib];
}
