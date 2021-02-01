{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-02-01";
    version = "unstable-${rev}";
    sha256 = "sha256-bPv51Jp6zJRdNJehuR8LVaBw/hubSeHbI5BeMwqEn4M=";
    cargoSha256 = "sha256-5g9wFQ6qlkJgSHLSLS0pad00XT7KflyGAq8/BknF9/M=";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
