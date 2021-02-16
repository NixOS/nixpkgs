{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-02-15";
    version = "unstable-${rev}";
    sha256 = "sha256-4Dgj2RQDe2FoOSXjL7oaHg8WlYX1vnc66LzzbXvTmjM=";
    cargoSha256 = "sha256-c6kr2PWSG3Sns6/O1zOVUFdkLWHAXcQ8LMeensCEuSk=";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
