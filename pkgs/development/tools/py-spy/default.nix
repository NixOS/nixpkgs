{ lib, stdenv, pkgsBuildBuild, rustPlatform, fetchFromGitHub, pkg-config, libunwind, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "py-spy";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "benfred";
    repo = "py-spy";
    rev = "v${version}";
    sha256 = "sha256-7282DGLNHpKorNTHvpMLmqF2DrEVMIiQIzf5nTuJ7lc=";
  };

  NIX_CFLAGS_COMPILE = "-L${libunwind}/lib";

  # error: linker `arm-linux-gnueabihf-gcc` not found
  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export RUSTFLAGS="-Clinker=$CC"
  '';

  checkInputs = [ python3 ];

  cargoSha256 = "sha256-qVnOuLNMAy+6MP+dh6vLiSXvwQBAwyzRnHzCP60BdWk=";

  meta = with lib; {
    description = "Sampling profiler for Python programs";
    license = licenses.mit;
    maintainers = [ maintainers.lnl7 ];
  };
}
