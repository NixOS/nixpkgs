{stdenv, fetchurl, aterm, toolbuslib, ptsupport, errorsupport}:

stdenv.mkDerivation {
  name = "sglr-3.12";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/sglr/sglr-3.12.tar.gz;
    md5 = "053753e419adfc337c4776412e3787ab";
  };
  inherit stdenv aterm ptsupport toolbuslib errorsupport;
  buildInputs = [stdenv aterm ptsupport toolbuslib errorsupport];
}
