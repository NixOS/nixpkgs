{stdenv, fetchurl, aterm, toolbuslib, ptsupport, errorsupport}:

stdenv.mkDerivation {
  name = "sdf-support-2.1.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/sdf-support/sdf-support-2.1.1.tar.gz;
    md5 = "28b2c044ee711d6c5f22772b7dfafb76";
  };
  inherit stdenv aterm ptsupport toolbuslib errorsupport;
  buildInputs = [stdenv aterm ptsupport toolbuslib errorsupport];
}
