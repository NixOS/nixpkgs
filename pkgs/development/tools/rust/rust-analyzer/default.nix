{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-08-17";
    version = "unstable-${rev}";
    sha256 = "1lkqhaygl6wak3hypmn3zb2h0v4n082xbpaywmzqr53vhw678sp0";
    cargoSha256 = "00a2fxq1kwybng3gp33lkad4c7wrz0gypigxkalqkyy4nbg3qil4";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
