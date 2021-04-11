{ pkgs, callPackage, CoreServices }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-04-05";
    version = "unstable-${rev}";
    sha256 = "sha256-ZDxy87F3uz8bTF1/2LIy5r4Nv/M3xe97F7mwJNEFcUs=";
    cargoSha256 = "sha256-kDwdKa08E0h24lOOa7ALeNqHlMjMry/ru1qwCIyKmuE=";

    inherit CoreServices;
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
