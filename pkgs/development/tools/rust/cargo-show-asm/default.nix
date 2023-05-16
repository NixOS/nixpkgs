{ lib
, rustPlatform
<<<<<<< HEAD
, fetchCrate
=======
, fetchFromGitHub
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, installShellFiles
, stdenv
, nix-update-script
, callPackage
}:

rustPlatform.buildRustPackage rec {
<<<<<<< HEAD
  pname = "cargo-show-asm";
  version = "0.2.21";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-0Fj+yC464XdqeMWBgBj5g6ZQGrurFM5LbqSe9GSgbGg=";
  };

  cargoHash = "sha256-fW+WvsZv34ZpwaRCs6Uom7t0cV+9yPIlN5pbRea9YEk=";
=======
  pname = "cargo-asm";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pacak";
    repo = "cargo-show-asm";
    rev = version;
    hash = "sha256-qsr28zuvu+i7P/MpwhDKQFFXTyFFo+vWrjBrpD1V8PY=";
  };

  cargoHash = "sha256-IL+BB08uZr5fm05ITxpm66jTb+pYYlLKOwQ8uf5rKSs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    changelog = "https://github.com/pacak/cargo-show-asm/blob/${version}/Changelog.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda oxalica matthiasbeyer ];
    mainProgram = "cargo-asm";
=======
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda oxalica ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
