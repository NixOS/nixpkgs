pkgs:

let
  inherit (pkgs)
    lib
    stdenv
    runCommand
    writeShellScript
  ;

  pkgConfigModuleProviders = import ./gather.nix pkgs;

  extraPkgConfigData = lib.importJSON ./extra-pkg-config-data.json;
in

stdenv.mkDerivation (finalAttrs: {
  name = "pkg-config-data.json";

  meta = {
    # Prevent Hydra from evaluating / building this derivation. Note that it
    # still may be built and evaluated via ./test-defaultPkgConfigPackages.nix
    # depending on jobset configuration.
    hydraPlatforms = [ ];
  };

  passAsFile = [ "text" ];
  text = builtins.toJSON {
    version = {
      major = 0;
      minor = 1;
    };

    # XXX comment
    modules = lib.recursiveUpdate extraPkgConfigData pkgConfigModuleProviders;
  };

  passthru = {
    tests.cachedData =
      runCommand "cached-pkg-config-data.json-up-to-date" {} ''
        diff -u "${./pkg-config-data.json}" "${finalAttrs.finalPackage}"
        touch "$out"
      '';

    updateCache = writeShellScript "update-pkg-config-data.json" ''
      set -euo pipefail

      export PATH="${lib.makeBinPath [ pkgs.git pkgs.nix pkgs.coreutils ]}"

      TMPDIR="$(mktemp -d)"
      cleanup() {
        rm -rf "$TMPDIR"
      }
      trap cleanup EXIT;

      cd "$(git rev-parse --show-toplevel)"

      newData="$(nix-build -A defaultPkgConfigPackagesDataJson --out-link "$TMPDIR/data-json")"
      cp "$newData" ./pkgs/top-level/pkg-config/pkg-config-data.json
    '';
  };

  # Work is mostly eval
  preferLocalBuild = true;

  nativeBuildInputs = [
    pkgs.buildPackages.jq
  ];

  buildCommand = ''
    jq . "$textPath" > "$out"
  '';
})
