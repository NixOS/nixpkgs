{ lib, newScope, stdenv, fetchurl }:
lib.makeScope newScope (self: rec {

  fetchAkku = { name, url, sha256, ... }:
    fetchurl {
      inherit url sha256;
    };

  akkuDerivation = self.callPackage ./akkuDerivation.nix { };
  akku = self.callPackage ./akku.nix { };

  akkuPackages =
    let
      overrides = self.callPackage ./overrides.nix { };
      makeAkkuPackage = akkuself: pname:
        { version, dependencies, dev-dependencies, license, url, sha256, source, synopsis ? "", homepage ? "", ... }:
        (akkuDerivation rec {
          inherit version pname;
          src = fetchAkku {
            inherit url sha256;
            name = pname;
          };
          buildInputs = builtins.map (x: akkuself.${x}) dependencies;
          r7rs = source == "snow-fort";
          nativeBuildInputs = builtins.map (x: akkuself.${x}) dev-dependencies;
          unpackPhase = "tar xf $src";

          meta.homepage = homepage;
          meta.description = synopsis;
          meta.license =
            let
              stringToLicense = s: (lib.licenses // (with lib.licenses; {
                "agpl" = agpl3Only;
                "artistic" = artistic2;
                "bsd" = bsd3;
                "bsd-1-clause" = bsd1;
                "bsd-2-clause" = bsd2;
                "bsd-3-clause" = bsd3;
                "gpl" = gpl3Only;
                "gpl-2" = gpl2Only;
                "gplv2" = gpl2Only;
                "gpl-3" = gpl3Only;
                "gpl-3.0" = gpl3Only;
                "gplv3" = gpl3Only;
                "lgpl" = lgpl3Only;
                "lgpl-2" = lgpl2Only;
                "lgpl-2.0+" = lgpl2Plus;
                "lgpl-2.1" = lgpl21Only;
                "lgpl-2.1-or-later" = lgpl21Plus;
                "lgpl-3" = lgpl3Only;
                "lgplv3" = lgpl3Only;
                "public-domain" = publicDomain;
                "srfi" = bsd3;
                "unicode" = ucd;
                "zlib-acknowledgement" = zlib;
              })).${s} or s;
            in
            if builtins.isList license
            then map stringToLicense license
            else stringToLicense license;
        }).overrideAttrs ({ "${pname}" = lib.id; } // overrides)."${pname}";
      deps = lib.importTOML ./deps.toml;
      packages = lib.makeScope self.newScope (akkuself: lib.mapAttrs (makeAkkuPackage akkuself) deps);
    in
    lib.recurseIntoAttrs packages;
})
