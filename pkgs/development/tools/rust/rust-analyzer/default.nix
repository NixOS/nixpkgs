{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-06-08";
    version = "unstable-${rev}";
    sha256 = "0ywwsb717d1rwcy2yij58sj123pan0fb80sbsiqqprcln0aaspip";
    cargoSha256 = "1c6rmrhx7q4qcanr26yzlwc2rp1hh55m80jn56hy6hfcvwcdaij4";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
