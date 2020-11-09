{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-11-09";
    version = "unstable-${rev}";
    sha256 = "sha256-SX9dvx2JtYZBxA3+dHQKX/jrjbAMy37/SAybDjlYcSs=";
    cargoSha256 = "sha256-+td+wMmI+MyGz9oPC+SPO2TmAV0+3lOORNY7xf6s3vI=";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
