{stdenv, fetchurl, cmake, openssl, nss, pkgconfig, nspr, bash}:
let
  s = # Generated upstream information
  rec {
    baseName="badvpn";
    version="1.999.129";
    name="${baseName}-${version}";
    hash="078gax6yifkf9y9g01wn1p0dypvgiwcsdmzp1bhwwfi0fbpnzzgl";
    url="https://github.com/ambrop72/badvpn/archive/1.999.129.tar.gz";
    sha256="078gax6yifkf9y9g01wn1p0dypvgiwcsdmzp1bhwwfi0fbpnzzgl";
  };
  buildInputs = [
    cmake openssl nss pkgconfig nspr
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  preConfigure = ''
    find . -name '*.sh' -exec sed -e 's@#!/bin/sh@${stdenv.shell}@' -i '{}' ';'
    find . -name '*.sh' -exec sed -e 's@#!/bin/bash@${bash}/bin/bash@' -i '{}' ';'
  '';

  meta = {
    inherit (s) version;
    description = ''A set of network-related (mostly VPN-related) tools'';
    license = stdenv.lib.licenses.bsd3 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
