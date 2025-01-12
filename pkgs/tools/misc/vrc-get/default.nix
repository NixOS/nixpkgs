{
  fetchCrate,
  installShellFiles,
  lib,
  rustPlatform,
  pkg-config,
  stdenv,
  buildPackages,
}:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "1.9.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-gZtaeq/PDVFZPIMH/cB/ZJNP+SbksPPbz8L8Hc7FDM8=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  cargoHash = "sha256-xfW9pIaSL9bvGXk4XxRUVyvtRwKXmjS3Gc5b7v7q17A=";

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
