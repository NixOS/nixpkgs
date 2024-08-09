{ stdenv, pkgs, lib, ... }:

let
  name = "xnode-personaliser";
  version = "v0.0.0-0xnodepkgs0";
  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = name;
    rev = "a85b06512149c0306d302038f70fba7c48530514";
    sha256 = "sha256-UlAc1/OtGalZONEWX5tE9VuLBmbq8lU7Bf5TkMCL49k=";
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
