{ fetchCrate, installShellFiles, lib, rustPlatform, pkg-config, stdenv, Security, SystemConfiguration, buildPackages }:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "1.8.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-j8B7g/w1Qtiuj099RlRLmrYTFiE7d2vVg/nTbaa8pRU=";
  };

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  cargoHash = "sha256-WFGY5osZIEYeHQchvuE3ddeqh2wzfZNV+SGqW08zYDI=";

  # Execute the resulting binary to generate shell completions, using emulation if necessary when cross-compiling.
  # If no emulator is available, then give up on generating shell completions
  postInstall =
    let
      vrc-get = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/vrc-get";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      installShellCompletion --cmd vrc-get \
        --bash <(${vrc-get} completion bash) \
        --fish <(${vrc-get} completion fish) \
        --zsh <(${vrc-get} completion zsh)
    '';

  meta = with lib; {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/vrc-get/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "vrc-get";
  };
}
