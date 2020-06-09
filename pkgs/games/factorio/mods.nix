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

  isBaseDependency = d: head (splitString " " d) == "base";
  isOptionalDependency = d: hasPrefix "?" d;
  isHiddenOptionalDependency = d: hasPrefix "(?)" d;
  isIncompatibleDependency = d: hasPrefix "!" d;

  isRequiredDependency = d: ! any (f: f d) [ isBaseDependency isOptionalDependency isHiddenOptionalDependency isIncompatibleDependency ];

  mods = listToAttrs (
    map
      (
        v:
          let
            depNames = map (s: head (splitString " " s)) (filter isRequiredDependency v.dependencies);
            deps = map (dep: mods."${dep}") depNames;
            optionalDepNames = map (s: findFirst (e: e != "?") (split " " s)) (filter isOptionalDependency v.dependencies);
            optionalDeps = map (dep: mods."${dep}") optionalDepNames;
          in
            {
              inherit (v) name;
              value = modDrv {
                name = "${v.name}-${v.version}";
                src = factorio-utils.fetchurlWithAuth ({ inherit username token; } // mkSrc v);
                inherit deps optionalDeps;
                # TODO: Add recommendedDeps.
              };
            }
      )
      (fromJSON (readFile ./mods.json))
  );

in
mods
