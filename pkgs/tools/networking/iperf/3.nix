{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-3.0.10";

  src = fetchurl {
    url = "http://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "17856cp4c6z4hh9jh3bvz2q2yfwhi1ybwf6mnaq822fgcwll84x1";
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
