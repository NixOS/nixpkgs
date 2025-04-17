{
  lib,
  stdenvNoCC,
  fetchurl,
  nixosTests,
  nextcloud28Packages,
  nextcloud29Packages,
  nextcloud30Packages,
  nextcloud31Packages,
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
    version = "28.0.14";
    hash = "sha256-SpN/GIJIZCbJcD5Z7EspP2Ib6NCAt/hQFvYpkDw68zY=";
    packages = nextcloud28Packages;
    eol = true;
  };

  nextcloud29 = generic {
    version = "29.0.16";
    hash = "sha256-SZv2GrGe3NTlQq+GYJJDxbT0QOtbsGwrp9oML6pSUyI=";
    packages = nextcloud29Packages;
  };

  nextcloud30 = generic {
    version = "30.0.10";
    hash = "sha256-40ldF8X1yRZFQtk/Y21pasyPOLYL7HDPGtLnnHbZlbo=";
    packages = nextcloud30Packages;
  };

  nextcloud31 = generic {
    version = "31.0.4";
    hash = "sha256-pHVBVm1casb2Pk9hfifaKVFW2kfaos0i7uNAD9KtElE=";
    packages = nextcloud31Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
