{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-3.0.9";

  src = fetchurl {
    url = "http://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "0n94d6n4nm9b88qyv1pqasrvxqc8kyqvqsdra1rr6syj60mrl920";
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
