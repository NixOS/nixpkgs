{ lib, stdenv, pkgsBuildBuild, rustPlatform, fetchFromGitHub, pkg-config, libunwind, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "py-spy";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "benfred";
    repo = "py-spy";
    rev = "v${version}";
    sha256 = "sha256-OiYYWLbdDrte0+YeJklt5pX2u2f4PnWJ4dyGWJBiTmQ=";
  };

  NIX_CFLAGS_COMPILE = "-L${libunwind}/lib";

  # error: linker `arm-linux-gnueabihf-gcc` not found
  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export RUSTFLAGS="-Clinker=$CC"
  '';

  checkInputs = [ python3 ];

  cargoSha256 = "sha256-Dn+1C+RRjxu8onejeKB9WsVGtthTy3Uit9jm2JtyN1w=";

  meta = with lib; {
    description = "Sampling profiler for Python programs";
    license = licenses.mit;
    maintainers = [ maintainers.lnl7 ];
  };
}
