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
    version = "32.0.14";
    hash = "sha512-2bO5WilP+dar/LnyHZ3qxFz6Q0fsG6mBGJzrEDvlHGbWkM1sUsBqA4sUyOQGGevyEr9biMNv1a7vXdOG75nHvA==";
    packages = nextcloud32Packages;
  };

  nextcloud33 = generic {
    version = "33.0.8";
    hash = "sha512-L5ryxWhjhUNnHMGBrY36/qoRVYmu39OiYkDYs8l7Wcer8v3fAUVooo0ESAaMBNcSzP2dB36CmbSxFD+BXdguPQ==";
    packages = nextcloud33Packages;
  };

  nextcloud34 = generic {
    version = "34.0.3";
    hash = "sha512-NGPbverlJ1oHkbEVz4au1BxaE4/dGbsy7BKDemaYEGtvFy4k+xJkotTiCyuAW894QbIzjk4C8f1TlPvtgwzGlQ==";
    packages = nextcloud34Packages;
  };

  # tip: get the sha with:
  # curl  "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha512" | grep '.tar.bz2'  | cut -f1 -d' ' | xargs nix hash convert --hash-algo sha512 --to sri
}
