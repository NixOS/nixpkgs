{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "srelay-0.4.8";

  src = fetchurl {
    url = "mirror://sourceforge/project/socks-relay/socks-relay/srelay-0.4.8/srelay-0.4.8.tar.gz";
    sha256 = "1sn6005aqyfvrlkm5445cyyaj6h6wfyskfncfmds55x34hfyxpvl";
  };

  patches = [ ./arm.patch ];

  installPhase = "install -D srelay $out/bin/srelay";

  meta = {
    description = "A SOCKS proxy and relay";
    homepage = http://socks-relay.sourceforge.net/;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.bsd3;
  };
}
