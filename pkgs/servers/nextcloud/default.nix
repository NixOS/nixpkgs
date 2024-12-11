{
  lib,
  stdenvNoCC,
  fetchurl,
  nixosTests,
  nextcloud28Packages,
  nextcloud29Packages,
  nextcloud30Packages,
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

      src = fetchurl {
        url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";
        inherit hash;
      };

      passthru = {
        tests = lib.filterAttrs (
          key: _: (lib.hasSuffix (lib.versions.major version) key)
        ) nixosTests.nextcloud;
        inherit packages;
      };

      installPhase = ''
        runHook preInstall
        mkdir -p $out/
        cp -R . $out/
        runHook postInstall
      '';

      meta = {
        changelog = "https://nextcloud.com/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
        description = "Sharing solution for files, calendars, contacts and more";
        homepage = "https://nextcloud.com";
        maintainers = with lib.maintainers; [
          schneefux
          bachp
          globin
          ma27
        ];
        license = lib.licenses.agpl3Plus;
        platforms = lib.platforms.linux;
        knownVulnerabilities =
          extraVulnerabilities ++ (lib.optional eol "Nextcloud version ${version} is EOL");
      };
    };
in
{
  nextcloud28 = generic {
    version = "28.0.12";
    hash = "sha256-KgDKT3mTYPCYf8vIXZmywlj30sz35vfgxMzxehJ/AQU=";
    packages = nextcloud28Packages;
  };

  nextcloud29 = generic {
    version = "29.0.10";
    hash = "sha256-pYY9nxOvF38n2IMxf5bD0XbnscpwsN3XlYSUWCtJRXc=";
    packages = nextcloud29Packages;
  };

  nextcloud30 = generic {
    version = "30.0.2";
    hash = "sha256-kpu4BF6WIW/iKmXc1mJ55b17oauynZm/QB1CO2RqRF8=";
    packages = nextcloud30Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
