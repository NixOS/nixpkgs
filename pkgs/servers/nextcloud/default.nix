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
    version = "32.0.12";
    hash = "sha256-rxWPclccjhXim8E2wjqSEYjOHVZoVQAK2U+JuAqPGAw=";
    packages = nextcloud32Packages;
  };

  nextcloud33 = generic {
    version = "33.0.6";
    hash = "sha256-eRghpVAplE3gQxnPyvysSujn71a0zR78JjG/MLedFt4=";
    packages = nextcloud33Packages;
  };

  nextcloud34 = generic {
    version = "34.0.1";
    hash = "sha256-BOnDL8P+Ofa2qKGJFe9a/SgKVrSn90Thj1+i7/+8SmM=";
    packages = nextcloud34Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
