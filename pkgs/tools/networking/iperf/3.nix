{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-3.0.8";

  src = fetchurl {
    url = "http://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "81b8d91159862896c57f9b90a006e8b5dc22bd94175d97bd0db50b0ae2c1a78e";
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
