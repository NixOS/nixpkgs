{ lib, stdenvNoCC, fetchurl, nixosTests
, nextcloud27Packages
, nextcloud28Packages
, nextcloud26Packages
}:

let
  generic = {
    version, hash
  , eol ? false, extraVulnerabilities ? []
  , packages
  }: stdenvNoCC.mkDerivation rec {
    pname = "nextcloud";
    inherit version;

    src = fetchurl {
      url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
      inherit hash;
    };

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

  nextcloud28 = generic {
    version = "28.0.1";
    hash = "sha256-L4BzW0Qwgicv5qO14yE3lX8fxEjHU0K5S1IAspcl86Q=";
    packages = nextcloud28Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
