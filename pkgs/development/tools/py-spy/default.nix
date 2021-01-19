{ lib, stdenv, pkgsBuildBuild, rustPlatform, fetchFromGitHub, pkg-config, libunwind, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "py-spy";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "benfred";
    repo = "py-spy";
    rev = "v${version}";
    sha256 = "1w9nwsmazafr78ghif6njdcqjisr0f1jb6cm1w4ngvigx5qlrbkv";
  };

  NIX_CFLAGS_COMPILE = "-L${libunwind}/lib";

  # error: linker `arm-linux-gnueabihf-gcc` not found
  preConfigure = stdenv.lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export RUSTFLAGS="-Clinker=$CC"
  '';

  checkInputs = [ python3 ];

  cargoSha256 = "0hrzmpwd2k4l8gjbry8ddrkv9q9qh8ag096md4q0fyn5bgnxhkah";

  meta = with lib; {
    description = "Sampling profiler for Python programs";
    license = licenses.mit;
    maintainers = [ maintainers.lnl7 ];
  };
}
