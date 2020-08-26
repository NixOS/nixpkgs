{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fping-5.0";

  src = fetchurl {
    url = "https://www.fping.org/dist/${name}.tar.gz";
    sha256 = "1f2prmii4fyl44cfykp40hp4jjhicrhddh9v3dfs11j6nsww0f7d";
  };

  configureFlags = [ "--enable-ipv6" "--enable-ipv4" ];

  meta = with stdenv.lib; {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
    license = licenses.bsd0;
    platforms = platforms.all;
  };
}
