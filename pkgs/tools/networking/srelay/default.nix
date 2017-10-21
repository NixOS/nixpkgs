{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "srelay-0.4.8b6";

  src = fetchurl {
    url = "mirror://sourceforge/project/socks-relay/socks-relay/srelay-0.4.8/srelay-0.4.8b6.tar.gz";
    sha256 = "1az9ds10hpmpw6bqk7fcd1w70001kz0mm48v3vgg2z6vrbmgn0qj";
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
