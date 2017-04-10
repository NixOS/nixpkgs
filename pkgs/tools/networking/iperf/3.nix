{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-3.1.7";

  src = fetchurl {
    url = "http://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "0kvk8d0a3dcxc8fisyprbn01y8akxj4sx8ld5dh508p9dx077vx4";
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
