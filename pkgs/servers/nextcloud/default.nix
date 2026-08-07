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
    version = "32.0.13";
    hash = "sha256-7rAaOJp2z+RfweD2GhW1x0vkDNKciuT1TNa0J817nvA=";
    packages = nextcloud32Packages;
  };

  nextcloud33 = generic {
    version = "33.0.7";
    hash = "sha256-uuGoL8u/TWmZTS1Y1OgVFm+/T+1a06VRIfOM4H7emRM=";
    packages = nextcloud33Packages;
  };

  nextcloud34 = generic {
    version = "34.0.2";
    hash = "sha256-Qc4x3xLMgQkMPQf+DouQveYckrGK6A5NZIutQ9eZEQE=";
    packages = nextcloud34Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
