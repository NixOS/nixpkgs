{
  lib,
  stdenvNoCC,
  fetchurl,
  nixosTests,
  nextcloud32Packages,
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
  nextcloud32 = generic {
    version = "32.0.15";
    hash = "sha256-aXSsEZUCXxNkPfF21Fas9FI3kNVIjCBbV1OfZCx9Fkw=";
    packages = nextcloud32Packages;
    eol = true;
  };

  nextcloud33 = generic {
    version = "33.0.10";
    hash = "sha256-QnEQuW/YWA2P6yOkCkHQBlfpdflF4ISEhaaibXd9fK4=";
    packages = nextcloud33Packages;
  };

  nextcloud34 = generic {
    version = "34.0.5";
    hash = "sha256-BOw93fRlyfLCqebuXzm4GDmdTz1YFVb0HQhyvutZsKk=";
    packages = nextcloud34Packages;
  };

  nextcloud35 = generic {
    version = "35.0.2";
    hash = "sha256-38eVXq7FYh3pDgMdEPdgBhc7Pz4x1dbhdIIdHaFPFi0=";
    packages = nextcloud35Packages;
  };

  # tip: get the sha with:
  # curl  "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha512" | grep '.tar.bz2'  | cut -f1 -d' ' | xargs nix hash convert --hash-algo sha512 --to sri
}
