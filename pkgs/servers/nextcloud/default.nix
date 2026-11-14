{
  lib,
  stdenvNoCC,
  fetchurl,
  nixosTests,
  nextcloud33Packages,
  nextcloud34Packages,
  nextcloud35Packages,
}:

let
  generic =
    {
      version,
      hash,
      eol ? false,
      extraVulnerabilities ? [ ],
      packages,
    }:
    stdenvNoCC.mkDerivation rec {
      pname = "nextcloud";
      inherit version;

      __structuredAttrs = true;
      strictDeps = true;

      src = fetchurl {
        url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";
        inherit hash;
      };

      installPhase = ''
        runHook preInstall
        mkdir -p $out/
        cp -R . $out/
        runHook postInstall
      '';

      passthru = {
        tests = lib.filterAttrs (
          key: _: (lib.hasSuffix (lib.versions.major version) key)
        ) nixosTests.nextcloud;
        inherit packages;
      };

      meta = {
        changelog = "https://nextcloud.com/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
        description = "Sharing solution for files, calendars, contacts and more";
        homepage = "https://nextcloud.com";
        teams = [ lib.teams.nextcloud ];
        license = lib.licenses.agpl3Plus;
        platforms = lib.platforms.linux;
        knownVulnerabilities =
          extraVulnerabilities ++ (lib.optional eol "Nextcloud version ${version} is EOL");
      };
    };
in
{
  nextcloud33 = generic {
    version = "33.0.11";
    hash = "sha256-MmDtP7wtJV/1tBZCfBUyBlHrfrwfpsBg6RbtkHUiEgU=";
    packages = nextcloud33Packages;
  };

  nextcloud34 = generic {
    version = "34.0.6";
    hash = "sha256-Hs7eBue+iTiMjBF+srf+J6i1Fx0vWlfGvDJHKBpWY4k=";
    packages = nextcloud34Packages;
  };

  nextcloud35 = generic {
    version = "35.0.3";
    hash = "sha256-WEAUQM6Bt/jURajCqAJ1crYW74NZL5axIf0V7Ioa7TU=";
    packages = nextcloud35Packages;
  };

  # tip: get the sha with:
  # curl  "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha512" | grep '.tar.bz2'  | cut -f1 -d' ' | xargs nix hash convert --hash-algo sha512 --to sri
}
