{ system ? builtins.currentSystem }:
let
  # nixpkgs / devshell is only used for development. Don't add it to the flake.lock.
  nixpkgsGitRev = "5268ee2ebacbc73875be42d71e60c2b5c1b5a1c7";
  devshellGitRev = "709fe4d04a9101c9d224ad83f73416dce71baf21";

  nixpkgsSrc = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgsGitRev}.tar.gz";
    sha256 = "080fvmg0i6z01h6adddfrjp1bbbjhhqk32ks6ch9gv689645ccfq";
  };


  devshellSrc = fetchTarball {
    url = "https://github.com/numtide/devshell/archive/${devshellGitRev}.tar.gz";
    sha256 = "1px9cqfshfqs1b7ypyxch3s3ymr4xgycy1krrcg7b97rmmszvsqr";
  };

  pkgs = import nixpkgsSrc { inherit system; };
  devshell = import devshellSrc { inherit system pkgs; };

in
devshell.fromTOML ./devshell.toml
