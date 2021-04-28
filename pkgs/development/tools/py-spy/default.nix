{ lib, stdenv, pkgsBuildBuild, rustPlatform, fetchFromGitHub, pkg-config, libunwind, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "py-spy";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "benfred";
    repo = "py-spy";
    rev = "v${version}";
    sha256 = "sha256-O6DbY/0ZI+BeG22jd9snbE718Y2vv7fqmeDdGWTnqfY=";
  };

  NIX_CFLAGS_COMPILE = "-L${libunwind}/lib";

  # error: linker `arm-linux-gnueabihf-gcc` not found
  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export RUSTFLAGS="-Clinker=$CC"
  '';

  checkInputs = [ python3 ];

  cargoSha256 = "sha256-GFH8RzyAMtdfoHPcCV3pKf24fKU65vhMLQfLtkhD0Ns=";

  meta = with lib; {
    description = "Sampling profiler for Python programs";
    license = licenses.mit;
    maintainers = [ maintainers.lnl7 ];
  };
}
