{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-11-02";
    version = "unstable-${rev}";
    sha256 = "1f64286ywsjw9s8kai3jw2dqnqswm2vnms6ilxx1x706mridxjv0";
    cargoSha256 = "0q53w43gag2pfb20jywikdbac291rvr1zmjnmwq462m5wfz0w127";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
