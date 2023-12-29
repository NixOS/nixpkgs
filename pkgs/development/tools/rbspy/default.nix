{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, ruby
, which
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rbspy";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-stZWTzrRk+dyscV+OtL5aEOv+MLrN3bMSIrhrZXmCfc=";
  };

  cargoHash = "sha256-pexYgL3gSeuglAQWn09nXgxQCUX+TFvnFU0uiwHEfzk=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config
  '';

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

  nativeBuildInputs = [ ruby which ]
    ++ lib.optional stdenv.isDarwin rustPlatform.bindgenHook;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://rbspy.github.io/";
    description = ''
      A Sampling CPU Profiler for Ruby.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
