{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  ruby,
  which,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rbspy";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "rbspy";
    repo = "rbspy";
    tag = "v${version}";
    hash = "sha256-KEF98h51F4sZ/eX08hggabnBji/8e/yJTP1VNzuLOlw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Wn5H+h7+UKm/AYRZ6e68E6W8h5bnweUPTsY2z6y4Ahc=";

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
    substituteInPlace src/core/ruby_spy.rs \
      --replace /usr/bin/ruby '${ruby}/bin/ruby'
  '';

  checkFlags = [
    "--skip=test_get_trace"
    "--skip=test_get_trace_when_process_has_exited"
    "--skip=test_sample_single_process"
    "--skip=test_sample_single_process_with_time_limit"
    "--skip=test_sample_subprocesses"
  ];

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin rustPlatform.bindgenHook;

  nativeCheckInputs = [
    ruby
    which
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://rbspy.github.io/";
    description = "Sampling CPU Profiler for Ruby";
    mainProgram = "rbspy";
    changelog = "https://github.com/rbspy/rbspy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
