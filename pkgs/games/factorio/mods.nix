{ stdenv
, factorio-utils
, allRecommendedMods ? true
, allOptionalMods ? false
, username ? ""
, token ? "" # get/reset token at https://factorio.com/profile
}:
with builtins;
with stdenv.lib;
let
  modDrv = factorio-utils.modDrv { inherit allRecommendedMods allOptionalMods; };

  mods = listToAttrs (
    map
      (v: {
        inherit (v) name;
        value = modDrv {
          name = "${v.name}-${v.version}";
          src = factorio-utils.fetchurlWithAuth (v.src // { inherit username token; });
          deps = map (dep: mods."${dep}") v.deps;
          optionalDeps = map (dep: mods."${dep}") v.optionalDeps;
          # TODO: Add recommendedDeps
        };
      })
      (fromJSON (readFile ./mods.json))
  );

in
mods
