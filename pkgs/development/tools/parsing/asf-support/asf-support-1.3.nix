{stdenv, fetchurl, aterm, ptsupport, errorsupport}:

stdenv.mkDerivation {
  name = "asf-support-1.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/asf-support/asf-support-1.3.tar.gz;
    md5 = "23539387ff9b0423c1c1933a8ff75d27";
  };
  inherit stdenv aterm ptsupport errorsupport;
  buildInputs = [stdenv aterm ptsupport errorsupport];
}
