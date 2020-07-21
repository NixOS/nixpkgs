{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-07-13";
    version = "unstable-${rev}";
    sha256 = "1mfhqq3wr2pxyr571xsyhlw4ikiqc0m7w6i31qmj4xq59klc003h";
    cargoSha256 = "09abiyc4cr47qxmvmc2az0addwxny0wpg9gilg8s8awgx1irxcqc";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
