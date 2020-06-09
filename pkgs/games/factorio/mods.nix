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

  mkSrc = let
    baseUrl = "https://mods.factorio.com/";
  in
    v: {
      name = v.file_name;
      url = baseUrl + v.download_url;
      inherit (v) sha1;
    };

  mods = listToAttrs (
    map
      (
        v: {
          inherit (v) name;
          value = modDrv {
            name = "${v.name}-${v.version}";
            src = factorio-utils.fetchurlWithAuth ({ inherit username token; } // mkSrc v);
            deps = map (dep: mods."${dep}") v.deps;
            optionalDeps = map (dep: mods."${dep}") v.optionalDeps;
            # TODO: Add recommendedDeps
          };
        }
      )
      (fromJSON (readFile ./mods.json))
  );

in
mods
