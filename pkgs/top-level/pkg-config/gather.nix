# SPDX-License-Identifier: MIT AND BSD-3-Clause
#
# Based on derivation-attr-paths.nix from distribution-nixpkgs
# https://github.com/NixOS/cabal2nix/blob/5cd07f1df825084fd47cf49cf49f14569859a51c/distribution-nixpkgs/derivation-attr-paths.nix
pkgs:

let
  inherit (pkgs) lib;

  /* Condition for us to recurse: Either we are at the top-level or
     recurseForDerivations is true.

     Type :: list any -> any -> bool
  */
  recurseInto = path: x: path == [] ||
    (lib.isAttrs x && (x.recurseForDerivations or false));

  defaultProviders = lib.importJSON ./default-providers.json;

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

  pkgConfigModuleAttrPaths = pkgs:
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
{
  version = {
    major = 0;
    minor = 1;
  };

  modules = pkgConfigModuleAttrPaths pkgs;
}
