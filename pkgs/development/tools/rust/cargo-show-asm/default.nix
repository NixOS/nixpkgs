{ lib
, rustPlatform
, fetchCrate
, installShellFiles
, stdenv
, nix-update-script
, callPackage
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-show-asm";
  version = "0.2.31";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-TjkEzqGFqhVKMmZEcwAoDnHOZWi7+wha228loJjLxgQ=";
  };

  cargoHash = "sha256-oUfBpx/hElXMw58Dj09JeG2FKy+biFt+4pb4pYNidxc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd cargo-asm \
      --bash <($out/bin/cargo-asm --bpaf-complete-style-bash) \
      --fish <($out/bin/cargo-asm --bpaf-complete-style-fish) \
      --zsh  <($out/bin/cargo-asm --bpaf-complete-style-zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenv.hostPlatform.isx86_64 {
      test-basic-x86_64 = callPackage ./test-basic-x86_64.nix { };
    };
  };

  meta = with lib; {
    description = "Cargo subcommand showing the assembly, LLVM-IR and MIR generated for Rust code";
    homepage = "https://github.com/pacak/cargo-show-asm";
    changelog = "https://github.com/pacak/cargo-show-asm/blob/${version}/Changelog.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda oxalica matthiasbeyer ];
    mainProgram = "cargo-asm";
  };
}
