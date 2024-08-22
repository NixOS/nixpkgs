{ callPackage, fetchFromGitHub, lib, pkgs }:
let
  nodePackages = import ./composition.nix { inherit pkgs; };
  sourceInfo = (lib.importJSON ./netlify-cli.json);
in
  nodePackages.package.override (o: {
    preRebuild = ''
      export ESBUILD_BINARY_PATH="${pkgs.esbuild_netlify}/bin/esbuild"
    '';
    src = fetchFromGitHub {
      inherit (sourceInfo) owner repo rev hash;
    };
    buildInputs = o.buildInputs ++ [
      pkgs.vips #??

      # node2nix does not allow nativeBuildInputs?
      pkgs.pkg-config #??
    ];
    SHARP_FORCE_GLOBAL_LIBVIPS = "1";
    # npmFlags = "--build-from-source --omit-dev"; #??
    bypassCache = true;
    reconstructLock = true;
    passthru.tests.test = callPackage ./test.nix { };
    # Useful for debugging
    passthru.nodePackages = nodePackages;
    meta.maintainers = with lib.maintainers; [ roberth ];
    meta.mainProgram = "netlify";
  })
