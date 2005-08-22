{stdenv, fetchurl, aterm, toolbuslib}: 

stdenv.mkDerivation {
  name = "error-support-0.1.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/error-support-0.1.1.tar.gz;
    md5 = "ebd0965e29ee22508a189477b1dae12b";
  };
  inherit aterm toolbuslib;
  buildInputs = [aterm toolbuslib];
}
