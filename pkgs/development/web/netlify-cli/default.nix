{ callPackage, fetchFromGitHub, lib, pkgs }:
let
  nodePackages = import ./composition.nix { inherit pkgs; };
  sourceInfo = (lib.importJSON ./netlify-cli.json);
in
  nodePackages.package.override {
    preRebuild = ''
      export ESBUILD_BINARY_PATH="${pkgs.esbuild_netlify}/bin/esbuild"
    '';
    src = fetchFromGitHub {
      inherit (sourceInfo) owner repo rev sha256;
    };
    bypassCache = true;
    reconstructLock = true;
    passthru.tests.test = callPackage ./test.nix { };
    meta.maintainers = with lib.maintainers; [ roberth ];
  }
