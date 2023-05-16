{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, ruby
, which
<<<<<<< HEAD
, nix-update-script
=======
, runCommand
, darwin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "rbspy";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NshDX7sbXnmK6k/EDD5thUcNKvSV4bNdJ5N2hNLlsnA=";
  };

  cargoHash = "sha256-JzspNL4T28awa/1Uajw0gLM3bYyUBYTjnfCXn9qG7SY=";
<<<<<<< HEAD

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = true;

  # The current implementation of rbspy fails to detect the version of ruby
  # from nixpkgs during tests.
  preCheck = ''
    substituteInPlace src/core/process.rs \
      --replace /usr/bin/which '${which}/bin/which'
    substituteInPlace src/sampler/mod.rs \
      --replace /usr/bin/which '${which}/bin/which'
  '';

  checkFlags = [
    "--skip=test_get_trace"
    "--skip=test_get_trace_when_process_has_exited"
    "--skip=test_sample_single_process"
    "--skip=test_sample_single_process_with_time_limit"
    "--skip=test_sample_subprocesses"
  ];

<<<<<<< HEAD
  nativeBuildInputs = [ ruby which ]
    ++ lib.optional stdenv.isDarwin rustPlatform.bindgenHook;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
=======
  nativeBuildInputs = [ ruby which ];

  buildInputs = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # Pull a header that contains a definition of proc_pid_rusage().
    (runCommand "${pname}_headers" { } ''
      install -Dm444 ${lib.getDev darwin.apple_sdk.sdk}/include/libproc.h $out/include/libproc.h
    '')
  ];

  LIBCLANG_PATH = lib.optionalString stdenv.isDarwin "${stdenv.cc.cc.lib}/lib";

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://rbspy.github.io/";
    description = ''
      A Sampling CPU Profiler for Ruby.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
