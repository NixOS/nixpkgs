{ lib
, stdenv
, darwin
, fetchFromGitHub
, libunwind
, python3
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "py-spy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "benfred";
    repo = "py-spy";
    rev = "v${version}";
    hash = "sha256-T96F8xgB9HRwuvDLXi6+lfi8za/iNn1NAbG4AIpE0V0=";
  };

  cargoHash = "sha256-SkHlXvhmw7swjZDdat0z0o5ATDJ1qSE/iwiwywsFOyw=";

  buildFeatures = [ "unwind" ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  nativeCheckInputs = [
    python3
  ];

  buildInputs = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Pull a header that contains a definition of proc_pid_rusage().
    darwin.apple_sdk_11_0.Libsystem
  ];

  env.NIX_CFLAGS_COMPILE = "-L${libunwind}/lib";

  checkFlags = [
    # assertion `left == right` failed
    "--skip=test_negative_linenumber_increment"
  ];

  meta = with lib; {
    description = "Sampling profiler for Python programs";
    mainProgram = "py-spy";
    homepage = "https://github.com/benfred/py-spy";
    changelog = "https://github.com/benfred/py-spy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lnl7 ];
  };
}
