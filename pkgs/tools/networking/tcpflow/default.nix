{stdenv, fetchurl, openssl, zlib, libpcap, boost, cairo}:
let
  s = # Generated upstream information
  rec {
    baseName="tcpflow";
    version="1.4.5";
    name="${baseName}-${version}";
    hash="0whcyykq710s84jyiaqp6rsr19prd0pr1g1pg74mif0ig51yv7zk";
    url="http://www.digitalcorpora.org/downloads/tcpflow/tcpflow-1.4.5.tar.gz";
    sha256="0whcyykq710s84jyiaqp6rsr19prd0pr1g1pg74mif0ig51yv7zk";
  };
  buildInputs = [
    openssl zlib libpcap boost cairo
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  meta = {
    inherit (s) version;
    description = ''TCP stream extractor'';
    license = stdenv.lib.licenses.gpl3 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
