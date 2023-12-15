{ lib, stdenv, fetchurl, nixosTests
, nextcloud27Packages
, nextcloud26Packages
, nextcloud25Packages
}:

let
  generic = {
    version, hash
  , eol ? false, extraVulnerabilities ? []
  , packages
  }: let
    major = lib.versions.major version;
  in stdenv.mkDerivation rec {
    pname = "nextcloud";
    inherit version;

    src = fetchurl {
      url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
      inherit hash;
    };

    # This patch is only necessary for NC version <26.
    patches = lib.optional (lib.versionOlder major "26") (./patches + "/v${major}/0001-Setup-remove-custom-dbuser-creation-behavior.patch");

    passthru = {
      tests = nixosTests.nextcloud;
      inherit packages;
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/
      cp -R . $out/
      runHook postInstall
    '';

    meta = with lib; {
      changelog = "https://nextcloud.com/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
      description = "Sharing solution for files, calendars, contacts and more";
      homepage = "https://nextcloud.com";
      maintainers = with maintainers; [ schneefux bachp globin ma27 ];
      license = licenses.agpl3Plus;
      platforms = with platforms; unix;
      knownVulnerabilities = extraVulnerabilities
        ++ (optional eol "Nextcloud version ${version} is EOL");
    };
  };
in {
  nextcloud24 = throw ''
    Nextcloud v24 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2023-04. Please upgrade to at least Nextcloud v25 by declaring

        services.nextcloud.package = pkgs.nextcloud25;

    in your NixOS config.

    WARNING: if you were on Nextcloud 23 you have to upgrade to Nextcloud 24
    first on 22.11 because Nextcloud doesn't support upgrades across multiple major versions!
  '';

  nextcloud25 = generic {
    version = "25.0.12";
    hash = "sha256-UgMYQkEdh7hjL47EEq14y0K9VIi+LT77/OSmhRykTYw=";
    packages = nextcloud25Packages;
  };

  nextcloud26 = generic {
    version = "26.0.10";
    hash = "sha256-yArkYMxOmvfQsJd6TJJX+t22a/V5OW9nwHfgLZsmlIw=";
    packages = nextcloud26Packages;
  };

  nextcloud27 = generic {
    version = "27.1.5";
    hash = "sha256-O1NMmOdrf+2Mo5NMrUGbEK9YViWfMTvsIs06e/pu+WE=";
    packages = nextcloud27Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
