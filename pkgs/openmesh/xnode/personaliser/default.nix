{ stdenv, pkgs, lib, ... }:

let
  name = "xnode-personaliser";
  version = "0.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = name;
    rev = "655cff7c0a8869fbc72323c3c76daec930a8f605";
    sha256 = "sha256-Dd678TQMkCS1kYKFeqXjk9nc2nKsE9ndPVcoc25k/xc=";
  };
in
(import "${src}/package.nix") {
  inherit stdenv;
  inherit pkgs;
  inherit lib;
  package-name = name;
  package-version = version;
  package-src = src;
}
