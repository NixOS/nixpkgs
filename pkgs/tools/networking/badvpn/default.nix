{stdenv, fetchurl, cmake, openssl, nss, pkgconfig, nspr, bash}:
let
  s = # Generated upstream information
  rec {
    baseName="badvpn";
    version="1.999.128";
    name="${baseName}-${version}";
    hash="1z4v1jydv8zkkszsq7scc17rw5dqz9zlpcc40ldxsw34arfqvcnn";
    url="http://badvpn.googlecode.com/files/badvpn-1.999.128.tar.bz2";
    sha256="1z4v1jydv8zkkszsq7scc17rw5dqz9zlpcc40ldxsw34arfqvcnn";
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
