{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-10-12";
    version = "unstable-${rev}";
    sha256 = "194xax87pwdh3p8zx46igvqwznlpnl4jp8lj987616gyldfgall0";
    cargoSha256 = "1rvf3a2fpqpf4q52pi676qzq7h0xfqlcbp15sc5vqc8nbbs7c7vw";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
