{lib, stdenv, fetchurl, cmake, openssl, nss, pkg-config, nspr, bash, debug ? false}:
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


  compileFlags = "-O3 ${lib.optionalString (!debug) "-DNDEBUG"}";
in
stdenv.mkDerivation {
  inherit (s) name version;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    openssl nss nspr
  ];
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
    description = "A set of network-related (mostly VPN-related) tools";
    license = lib.licenses.bsd3 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
}
