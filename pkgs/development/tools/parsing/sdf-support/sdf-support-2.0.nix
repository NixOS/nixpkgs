{stdenv, fetchurl, aterm, toolbuslib, ptsupport}:

stdenv.mkDerivation {
  name = "sdf-support-2.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/sdf-support/sdf-support-2.0.tar.gz;
    md5 = "2987b89ed1d73e34e128b895ff44264c";
  };
  inherit stdenv aterm ptsupport toolbuslib;
  buildInputs = [stdenv aterm ptsupport toolbuslib];
}
