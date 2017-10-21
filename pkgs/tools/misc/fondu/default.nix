{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "060102";
  name = "fondu-${version}";

  src = fetchurl {
    url = "http://fondu.sourceforge.net/fondu_src-${version}.tgz";
    sha256 = "152prqad9jszjmm4wwqrq83zk13ypsz09n02nrk1gg0fcxfm7fr2";
  };

  makeFlags = "DESTDIR=$(out)";

  hardeningDisable = [ "fortify" ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
