{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-3.2";

  src = fetchurl {
    url = "http://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "07cwrl9q5pmfjlh6ilpk7hm25lpkcaf917zhpmfq918lhrpv61zj";
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
