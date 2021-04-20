{ system ? builtins.currentSystem }:
let
  # nixpkgs / devshell is only used for development. Don't add it to the flake.lock.
  devshellGitRev = "709fe4d04a9101c9d224ad83f73416dce71baf21";

  nixpkgsSrc = ./.;

  devshellSrc = fetchTarball {
    url = "https://github.com/numtide/devshell/archive/${devshellGitRev}.tar.gz";
    sha256 = "1px9cqfshfqs1b7ypyxch3s3ymr4xgycy1krrcg7b97rmmszvsqr";
  };

  pkgs = import nixpkgsSrc { inherit system; };
  devshell = import devshellSrc { inherit system pkgs; };

in
devshell.fromTOML ./devshell.toml
