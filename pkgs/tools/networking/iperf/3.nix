{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-3.1.3";

  src = fetchurl {
    url = "http://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "1gwmhm29zlp5grrpglmqj7vgx19s6xy33hk6hpbn8jnpn5lxpn30";
  };

  postInstall = ''
    ln -s iperf3 $out/bin/iperf
  '';

  meta = with stdenv.lib; {
    homepage = http://software.es.net/iperf/; 
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = "as-is";
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
