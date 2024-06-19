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
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "benfred";
    repo = "py-spy";
    rev = "refs/tags/v${version}";
    hash = "sha256-NciyzKiDKIMeuHhTjzmHIc3dYW4AniuCNjZugm4hMss=";
  };

  cargoHash = "sha256-nm+44YWSJOOg9a9d8b3APXW50ThV3iA2C/QsJMttscE=";

  # error: linker `arm-linux-gnueabihf-gcc` not found
  postPatch = ''
    rm .cargo/config
  '';

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  nativeCheckInputs = [
    python3
  ];

  buildInputs = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # Pull a header that contains a definition of proc_pid_rusage().
    darwin.apple_sdk_11_0.Libsystem
  ];

  env.NIX_CFLAGS_COMPILE = "-L${libunwind}/lib";

  checkFlags = [
    # thread 'python_data_access::tests::test_copy_string' panicked at 'called `Result::unwrap()` on an `Err`
    "--skip=python_data_access::tests::test_copy_string"
  ] ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
    # panicked at 'called `Result::unwrap()` on an `Err` value: failed to get os threadid
    "--skip=test_thread_reuse"
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
