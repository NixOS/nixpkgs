{stdenv, fetchurl, aterm, toolbuslib}: 

stdenv.mkDerivation {
  name = "error-support-0.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/error-support/error-support-0.1.tar.gz;
    md5 = "906389fd8b44bf2847d8281450d5a701";
  };
  inherit aterm toolbuslib;
  buildInputs = [aterm toolbuslib];
}
