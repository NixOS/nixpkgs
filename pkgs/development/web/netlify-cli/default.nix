{ callPackage, fetchFromGitHub, lib, pkgs }:
let
  nodePackages = import ./composition.nix { inherit pkgs; };
  meta = (lib.importJSON ./netlify-cli.json);
in
  nodePackages.package.override {
    preRebuild = ''
      export ESBUILD_BINARY_PATH="${pkgs.esbuild_netlify}/bin/esbuild"
    '';
    src = fetchFromGitHub {
      owner = meta.owner;
      repo = meta.repo;
      rev = meta.rev;
      sha256 = meta.sha256;
    };
    bypassCache = true;
    reconstructLock = true;
    passthru.tests.test = callPackage ./test.nix { };
    meta.maintainers = with lib.maintainers; [ roberth ];
  }
