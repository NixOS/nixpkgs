{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  openssl,
}:
let
  makefile = if stdenv.isDarwin then "makefile.mac" else "makefile";
in
stdenv.mkDerivation rec {
  pname = "ibm-sw-tpm2";
  version = "1682";

  src = fetchurl {
    url = "mirror://sourceforge/ibmswtpm2/ibmtpm${version}.tar.gz";
    hash = "sha256-PLZC+HGheyPVCwRuX5X0ScIodBX8HnrrS9u4kg28s48=";
  };

  patches = [
    # Backport openssl-3.1 from development branch.
    # Can be removed with next release.
    (fetchpatch {
      name = "openssl-3.1.patch";
      url = "https://github.com/kgoldman/ibmswtpm2/commit/15501bf4973d334ca9420fa2fb0f0fe1800871e0.patch";
      includes = [ "TpmToOsslMath.h" ];
      stripLen = 1;
      hash = "sha256-8TwyZVy8pQwq5Fl8cy9xJWtdckwL+QK0+DL5EHDLYUY=";
    })
  ];

  buildInputs = [ openssl ];

  sourceRoot = "src";

  inherit makefile;

  prePatch = ''
    # Fix hardcoded path to GCC.
    substituteInPlace ${makefile} --replace /usr/bin/gcc "${stdenv.cc}/bin/cc"

    # Remove problematic default CFLAGS.
    substituteInPlace ${makefile} \
      --replace -Werror "" \
      --replace -O0 "" \
      --replace -ggdb ""
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tpm_server $out/bin
  '';

  meta = with lib; {
    description = "IBM's Software TPM 2.0, an implementation of the TCG TPM 2.0 specification";
    mainProgram = "tpm_server";
    homepage = "https://sourceforge.net/projects/ibmswtpm2/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ tomfitzhenry ];
    license = licenses.bsd3;
  };
}
