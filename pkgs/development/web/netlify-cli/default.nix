{ pkgs, lib, fetchFromGitHub }:
let
  nodePackages = import ./composition.nix { inherit pkgs; };
in
  nodePackages.package.override {
    preRebuild = ''
      export ESBUILD_BINARY_PATH="${pkgs.esbuild_netlify}/bin/esbuild"
    '';
    src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./netlify-cli.json));
    bypassCache = true;
    reconstructLock = true;
    meta.maintainers = with lib.maintainers; [ roberth ];
  }
