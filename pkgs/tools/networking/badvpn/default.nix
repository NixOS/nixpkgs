{stdenv, fetchurl, cmake, openssl, nss, pkgconfig, nspr, bash}:
let
  s = # Generated upstream information
  rec {
    baseName="badvpn";
    version="http://badvpn.googlecode.com/files/badvpn-openwrt.tar.bz2";
    name="${baseName}-${version}";
    hash="1sr7i52msdjy8g7mrgwgqn3fqfvfjs48nz3waxf8r7wg1livvl2b";
    url="http://badvpn.googlecode.com/files/badvpn-openwrt.tar.bz2";
    sha256="1sr7i52msdjy8g7mrgwgqn3fqfvfjs48nz3waxf8r7wg1livvl2b";
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
