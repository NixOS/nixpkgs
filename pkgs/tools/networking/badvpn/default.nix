{ lib, stdenv, fetchurl, cmake, openssl, nss, pkg-config, nspr, bash, debug ? false }:

stdenv.mkDerivation rec {
  pname = "badvpn";
  version = "1.999.130";
  src = fetchurl {
    url = "https://github.com/ambrop72/badvpn/archive/${version}.tar.gz";
    sha256 = "sha256-v9S7/r1ydLzseSVYyaL9YOOc2S4EZzglreXQQVR2YQk=";
  };
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    openssl
    nss
    nspr
  ];

  preConfigure = ''
    find . -name '*.sh' -exec sed -e 's@#!/bin/sh@${stdenv.shell}@' -i '{}' ';'
    find . -name '*.sh' -exec sed -e 's@#!/bin/bash@${bash}/bin/bash@' -i '{}' ';'
    cmakeFlagsArray=("-DCMAKE_BUILD_TYPE=" "-DCMAKE_C_FLAGS=-O3 ${lib.optionalString (!debug) "-DNDEBUG"}");
  '';

  meta = with lib; {
    description = "A set of network-related (mostly VPN-related) tools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
