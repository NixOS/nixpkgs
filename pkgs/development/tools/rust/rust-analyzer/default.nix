{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-08-24";
    version = "unstable-${rev}";
    sha256 = "11q5shrq55krgpj7rjfqw84131j5g55zyrwww3cxcbr8ndi3xdnf";
    cargoSha256 = "15kjcgxmigm0lwbp8p0kdxax86ldjqq9q8ysj6khfhqd0173184n";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
