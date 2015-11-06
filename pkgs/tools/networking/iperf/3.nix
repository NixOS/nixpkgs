{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-3.1";

  src = fetchurl {
    url = "http://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "0mp6bhfbkkcrdc2sl65k0g5x5csnccqrjk3bc3a0kjr5rqpa71a3";
  };

  postInstall = ''
    ln -s iperf3 $out/bin/iperf
  '';

  meta = with stdenv.lib; {
    homepage = http://software.es.net/iperf/; 
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = "as-is";
    maintainers = with maintainers; [ wkennington ];
  };
}
