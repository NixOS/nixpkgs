{stdenv, fetchurl, aterm, toolbuslib, errorsupport}: 

stdenv.mkDerivation {
  name = "pt-support-1.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/pt-support/pt-support-1.2.tar.gz;
    md5 = "2ba2fa388130b11b9b91970ebe20c1c7";
  };
  inherit aterm toolbuslib errorsupport;
  buildInputs = [aterm toolbuslib errorsupport];
}
