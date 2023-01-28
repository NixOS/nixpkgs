{ python3
, rustPlatform
}:

python3.pkgs.callPackage ./generic.nix {
  buildAndTestSubdir = "examples/word-count";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];
}
