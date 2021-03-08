{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-01-04";
    version = "unstable-${rev}";
    sha256 = "sha256-VRnmx5SfmdMIVQjixWBSaMioqFUlo9VOIKsPvC5t3t4=";
    cargoSha256 = "sha256-X63FjFpfwjvQayw4X6Sqfyh4FHsc3flE3OtQpzqowjc=";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
