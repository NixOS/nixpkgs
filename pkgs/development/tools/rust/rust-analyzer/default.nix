{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-04-20";
    version = "unstable-${rev}";
    sha256 = "00v8b6pbm5fry6bfkrfd7phn0ps8annqrw9k71m3pd26sxnn1q5f";
    cargoSha256 = "0nd86gwlfjwdkcphpk8zvs95xxdm8p74wl7vcrx8fnvvfxnkpwmc";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
