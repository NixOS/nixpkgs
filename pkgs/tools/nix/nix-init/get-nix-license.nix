# vendored from src/get-nix-license.nix

{ lib, writeText }:

let
  inherit (lib)
    attrNames
    concatMapAttrs
    concatStringsSep
    filterAttrs
    flip
    id
    intersectLists
    licenses
    mapAttrsToList
    optionalAttrs
    pipe
    warn
    ;

  licenseMap = flip concatMapAttrs licenses
    (k: v: optionalAttrs (v ? spdxId && !v.deprecated) { ${v.spdxId} = k; });

  deprecatedAliases = {
    "AGPL-3.0" = "agpl3Only";
    "BSD-2-Clause-FreeBSD" = "bsd2WithViews";
    "BSD-2-Clause-NetBSD" = "bsd2";
    "GFDL-1.1" = "fdl11Only";
    "GFDL-1.2" = "fdl12Only";
    "GFDL-1.3" = "fdl13Only";
    "GPL-1.0" = "gpl1Only";
    "GPL-1.0+" = "gpl1Plus";
    "GPL-2.0" = "gpl2Only";
    "GPL-2.0+" = "gpl2Plus";
    "GPL-3.0" = "gpl3Only";
    "GPL-3.0+" = "gpl3Plus";
    "LGPL-2.0" = "lgpl2Only";
    "LGPL-2.0+" = "lgpl2Plus";
    "LGPL-2.1" = "lgpl21Only";
    "LGPL-2.1+" = "lgpl21Plus";
    "LGPL-3.0" = "lgpl3Only";
    "LGPL-3.0+" = "lgpl3Plus";
  };

  lints = {
    "deprecated licenses" = intersectLists
      (attrNames licenseMap)
      (attrNames deprecatedAliases);

    "invalid aliases" = attrNames (filterAttrs
      (k: v: licenses.${v}.deprecated or true)
      deprecatedAliases);
  };

  lint = flip pipe
    (flip mapAttrsToList lints (k: v:
      if v == [ ] then
        id
      else
        warn "${k}: ${concatStringsSep ", " v}"));

  arms = lint (concatStringsSep "\n        "
    (mapAttrsToList
      (k: v: ''"${k}" => Some("${v}"),'')
      (deprecatedAliases // licenseMap)));
in

writeText "get-nix-license.rs" ''
  pub fn get_nix_license(license: &str) -> Option<&'static str> {
      match license {
          ${arms}
          _ => None,
      }
  }
''
