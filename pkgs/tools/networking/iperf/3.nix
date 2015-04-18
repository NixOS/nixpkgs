{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-3.0.11";

  src = fetchurl {
    url = "http://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "0vkzx7yxhah49l83jb5r3y4zzfdqypj5y2b3fjc7rxj7dyzba7g0";
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
