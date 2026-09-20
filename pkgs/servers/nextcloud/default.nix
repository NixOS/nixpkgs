{
  lib,
  stdenvNoCC,
  fetchurl,
  nixosTests,
  nextcloud32Packages,
  nextcloud33Packages,
  nextcloud34Packages,
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
  nextcloud32 = generic {
    version = "32.0.15";
    hash = "sha256-aXSsEZUCXxNkPfF21Fas9FI3kNVIjCBbV1OfZCx9Fkw=";
    packages = nextcloud32Packages;
    eol = true;
  };

  nextcloud33 = generic {
    version = "33.0.9";
    hash = "sha256-8zHBBB0CfmWIUm0qAM5CvHCpYi6rWHHAvpF3JSz3dCM=";
    packages = nextcloud33Packages;
  };

  nextcloud34 = generic {
    version = "34.0.4";
    hash = "sha256-APIm5jZPluCRirBhVxWPZmAbjO3CWvd39e5aMFb0K4M=";
    packages = nextcloud34Packages;
  };

  # tip: get the sha with:
  # curl  "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha512" | grep '.tar.bz2'  | cut -f1 -d' ' | xargs nix hash convert --hash-algo sha512 --to sri
}
