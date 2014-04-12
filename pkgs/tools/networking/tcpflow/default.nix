{stdenv, fetchurl, openssl, zlib, libpcap, boost, cairo}:
let
  s = # Generated upstream information
  rec {
    baseName="tcpflow";
    version="1.4.4";
    name="${baseName}-${version}";
    hash="0k2lxlvn1x8avkrijc22scrj4p2g5agfskbgfc2d0w9zgrg61xdn";
    url="http://www.digitalcorpora.org/downloads/tcpflow/tcpflow-1.4.4.tar.gz";
    sha256="0k2lxlvn1x8avkrijc22scrj4p2g5agfskbgfc2d0w9zgrg61xdn";
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
