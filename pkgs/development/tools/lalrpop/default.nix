{
  lib,
  rustPlatform,
  fetchFromGitHub,
  substituteAll,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "lalrpop";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "lalrpop";
    repo = "lalrpop";
    # there's no tag for 0.20.0
    rev = "1584ddb243726195b540fdd2b3ccf693876288e0";
    # rev = version;
    hash = "sha256-aYlSR8XqJnj76Hm3MFqfA5d9L3SO/iCCKpzOES5YQGY=";
  };

  cargoHash = "sha256-JaU5ZJbmlV/HfFT/ODpB3xFjZc2XiljhEVz/dql8o/c=";

  patches = [
    (substituteAll {
      src = ./use-correct-binary-path-in-tests.patch;
      target_triple = stdenv.hostPlatform.rust.rustcTarget;
    })
  ];

  buildAndTestSubdir = "lalrpop";

  # there are some tests in lalrpop-test and some in lalrpop
  checkPhase = ''
    buildAndTestSubdir=lalrpop-test cargoCheckHook
    cargoCheckHook
  '';

  meta = with lib; {
    description = "LR(1) parser generator for Rust";
    homepage = "https://github.com/lalrpop/lalrpop";
    changelog = "https://github.com/lalrpop/lalrpop/blob/${src.rev}/RELEASES.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    mainProgram = "lalrpop";
    maintainers = with maintainers; [ chayleaf ];
  };
}
