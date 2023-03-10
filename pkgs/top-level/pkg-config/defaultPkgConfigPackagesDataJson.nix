# SPDX-License-Identifier: MIT AND BSD-3-Clause
#
# `pkgConfigModuleProviders` is based on derivation-attr-paths.nix from the
# NixOS/distribution-nixpkgs Haskell package:
# https://github.com/NixOS/cabal2nix/blob/5cd07f1d/distribution-nixpkgs/derivation-attr-paths.nix

pkgs:

let
  inherit (pkgs)
    lib
    stdenv
    runCommand
    writeShellScript
  ;

  # Manually maintained data file that declares the attribute path to use for a
  # given pkg-config module if there are multiple packages in pkgs that provide
  # this module.
  defaultProviders = lib.importJSON ./default-providers.json;

  # Manually maintained data file that allows adding extra data to the generated
  # pkg-config-data.json file. The final file is calculated using
  # `lib.recursiveUpdate extraPkgConfigData calculatedPkgConfigData`. Note that
  # it is not possible to overwrite calculated data in the final
  # pkg-config-data.json file using this mechanism.
  extraPkgConfigData = lib.importJSON ./extra-pkg-config-data.json;

  # Recursion Condition: Either we are at the top-level or recurseForDerivations
  # is true. The caller is expected to check if we are looking at an attribute
  # set or a derivation.
  recurseInto = path: x: path == [ ] ||
    (lib.isAttrs x && (x.recurseForDerivations or false));

  # This function looks at all the packages that provide a given pkg-config
  # module and (in the event of a conflict) picks the default one as declared
  # in `defaultProviders`. Additionally, the data is validated and any warnings
  # or errors reported to the user.
  pickDefaultProvider = pkgConfigModule: alternatives:
    let
      count = builtins.length alternatives;
      dataPath = toString ./default-providers.json;

      default = defaultProviders.${pkgConfigModule} or null;
    in
    if count == 1 then
      lib.warnIf (default != null) "Unnecessary entry for ${pkgConfigModule} in ${dataPath}"
      builtins.head alternatives
    else
      if default == null then
        throw ''
          Found ${toString count} providers for '${pkgConfigModule}', but no default
          provider selection in '${dataPath}'. Alternatives are:

          ${lib.concatMapStringsSep "\n" builtins.toJSON alternatives}
        ''
      else if !(builtins.elem default alternatives) then
        throw "Default provider '${builtins.toJSON default}' for '${pkgConfigModule}' selected in '${dataPath}' not found in 'pkgs'"
      else default;

  # Function that takes `pkgs` and calculates a map from pkg-config module name
  # to an attribute set containing (at the moment) the `attrPath` of a package in
  # `pkgs` providing the module:
  #
  #     {
  #       "pkg-config-module-name" = {
  #         attrPath = [
  #           "pkg-name"
  #         ];
  #       };
  #       # …
  #     }
  #
  # The function uses `meta.pkgConfigModules` to determine what modules a package
  # provides, respects `recurseForDerivation` when walking the package set and
  # will filter out any package that has `meta.hydraPlatform == [ ]` (e.g. aliases).
  #
  # Note that the result of this functions is not the same as the `modules` key
  # in pkg-config-data.json – some extra meta data is sourced differently and
  # added later in the generation process.
  #
  # External consumers should in general rely on the cached pkg-config-data.json,
  # but can rely on this function in special circumstances (it is re-exposed via
  # `defaultPkgConfigPackagesDataJson.pkgConfigModuleProviders`). It is, however,
  # not stable.
  pkgConfigModuleProviders = pkgs:
    let
      go = attrPath: x:
        let
          inherit (builtins.tryEval x) value success;
        in
          if !success then [ ]
          else if lib.isDerivation value
                  # All alias infrastructure should call dontDistribute on the
                  # aliased packages which should allow us to detect them.
                  && !(value.meta.hydraPlatforms or null == [ ])
                  && value ? meta.pkgConfigModules then
            builtins.map
              (pkgConfigModule: { ${pkgConfigModule} = { inherit attrPath; }; })
              value.meta.pkgConfigModules
          else if recurseInto attrPath x then
            lib.concatLists (
              lib.mapAttrsToList (n: go (attrPath ++ [ n ])) x
            )
          else [ ];
    in
      lib.zipAttrsWith
        pickDefaultProvider
        (go [ ] pkgs);
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

    # See note for extraPkgConfigData above
    modules = lib.recursiveUpdate extraPkgConfigData (pkgConfigModuleProviders pkgs);
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

    inherit pkgConfigModuleProviders;
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
