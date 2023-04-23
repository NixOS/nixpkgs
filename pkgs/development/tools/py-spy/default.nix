{ lib
, stdenv
, darwin
, fetchFromGitHub
, libunwind
, pkg-config
, pkgsBuildBuild
, python3
, runCommand
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "py-spy";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "benfred";
    repo = "py-spy";
    rev = "refs/tags/v${version}";
    hash = "sha256-NciyzKiDKIMeuHhTjzmHIc3dYW4AniuCNjZugm4hMss=";
  };

  cargoHash = "sha256-nm+44YWSJOOg9a9d8b3APXW50ThV3iA2C/QsJMttscE=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  nativeCheckInputs = [
    python3
  ];

  buildInputs = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # Pull a header that contains a definition of proc_pid_rusage().
    (runCommand "${pname}_headers" { } ''
      install -Dm444 ${lib.getDev darwin.apple_sdk.sdk}/include/libproc.h $out/include/libproc.h
    '')
  ];

  env.NIX_CFLAGS_COMPILE = "-L${libunwind}/lib";

  # error: linker `arm-linux-gnueabihf-gcc` not found
  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export RUSTFLAGS="-Clinker=$CC"
  '';

  checkFlags = [
    # thread 'python_data_access::tests::test_copy_string' panicked at 'called `Result::unwrap()` on an `Err`
    "--skip=python_data_access::tests::test_copy_string"
  ];

  meta = with lib; {
    description = "Sampling profiler for Python programs";
    homepage = "https://github.com/benfred/py-spy";
    changelog = "https://github.com/benfred/py-spy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lnl7 ];
  };
}
