{ lib, stdenv, pkgsBuildBuild, rustPlatform, fetchFromGitHub, pkg-config, libunwind, python3, runCommand, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "py-spy";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "benfred";
    repo = "py-spy";
    rev = "v${version}";
    sha256 = "sha256-NciyzKiDKIMeuHhTjzmHIc3dYW4AniuCNjZugm4hMss=";
  };

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # Pull a header that contains a definition of proc_pid_rusage().
    (runCommand "${pname}_headers" { } ''
      install -Dm444 ${lib.getDev darwin.apple_sdk.sdk}/include/libproc.h $out/include/libproc.h
    '')
  ];

  NIX_CFLAGS_COMPILE = "-L${libunwind}/lib";

  # error: linker `arm-linux-gnueabihf-gcc` not found
  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export RUSTFLAGS="-Clinker=$CC"
  '';

  nativeCheckInputs = [ python3 ];

  cargoSha256 = "sha256-nm+44YWSJOOg9a9d8b3APXW50ThV3iA2C/QsJMttscE=";

  meta = with lib; {
    description = "Sampling profiler for Python programs";
    license = licenses.mit;
    maintainers = [ maintainers.lnl7 ];
  };
}
