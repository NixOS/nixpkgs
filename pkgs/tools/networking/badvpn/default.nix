{stdenv, fetchurl, cmake, openssl, nss, pkgconfig, nspr, bash, debug ? false}:
let
  s = # Generated upstream information
  rec {
    baseName="badvpn";
    version="1.999.130";
    name="${baseName}-${version}";
    hash="02b1fra43l75mljkhrq45vcrrqv0znicjn15g7nbqx3jppzbpm5z";
    url="https://github.com/ambrop72/badvpn/archive/1.999.130.tar.gz";
    sha256="02b1fra43l75mljkhrq45vcrrqv0znicjn15g7nbqx3jppzbpm5z";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake openssl nss nspr
  ];
  compileFlags = "-O3 ${stdenv.lib.optionalString (!debug) "-DNDEBUG"}";
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
    cmakeFlagsArray=("-DCMAKE_BUILD_TYPE=" "-DCMAKE_C_FLAGS=${compileFlags}");
  '';

  meta = {
    inherit (s) version;
    description = ''A set of network-related (mostly VPN-related) tools'';
    license = stdenv.lib.licenses.bsd3 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
