{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-01-18";
    version = "unstable-${rev}";
    sha256 = "sha256-eFiZdFBJZuBfwH8tqZTayNaWiq8fWUzlzBRRvdPbmW8=";
    cargoSha256 = "sha256-rRoo0TrXa03okJ8wktzVSAn8tRO1d9kcDprotZ1hZ6w=";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
