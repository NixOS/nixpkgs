{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "iperf-3.3";

  src = fetchurl {
    url = "http://downloads.es.net/pub/iperf/${name}.tar.gz";
    sha256 = "1n442bjkm1dvzmcj8z1i99yrmba489yz3f5v27ybymhh4mqn4nbg";
  };

  buildInputs = [ openssl ];

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
