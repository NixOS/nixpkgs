{stdenv, fetchurl, aterm, toolbuslib, errorsupport}: 

stdenv.mkDerivation {
  name = "pt-support-1.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/pt-support-1.1.tar.gz;
    md5 = "51bad46427c7cf95d029c33f079581ff";
  };
  inherit aterm toolbuslib errorsupport;
  buildInputs = [aterm toolbuslib errorsupport];
}
