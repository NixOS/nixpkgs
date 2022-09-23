{ callPackage, fetchFromGitHub, lib, pkgs }:
let
  nodePackages = import ./composition.nix { inherit pkgs; };
in
  nodePackages.package.override {
    preRebuild = ''
      export ESBUILD_BINARY_PATH="${pkgs.esbuild_netlify}/bin/esbuild"
    '';
    src = fetchFromGitHub (lib.importJSON ./netlify-cli.json);
    bypassCache = true;
    reconstructLock = true;
    passthru.tests.test = callPackage ./test.nix { };
    meta.maintainers = with lib.maintainers; [ roberth ];
  }
