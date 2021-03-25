{ callPackage
, rustPlatform
}:

callPackage ./generic.nix {
  buildAndTestSubdir = "examples/word-count";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];
}
