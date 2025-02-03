{ lib, stdenvNoCC, fetchurl, nixosTests
, nextcloud27Packages
, nextcloud28Packages
, nextcloud29Packages
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
      platforms = platforms.linux;
      knownVulnerabilities = extraVulnerabilities
        ++ (optional eol "Nextcloud version ${version} is EOL");
    };
  };
in {
  nextcloud27 = generic {
    version = "27.1.9";
    hash = "sha256-+P4QzLWFNJ+EUQ25tLAgjbfziV2vPXpejxfSNuzEEfU=";
    packages = nextcloud27Packages;
  };

  nextcloud28 = generic {
    version = "28.0.5";
    hash = "sha256-3KEQD5W4ZLreETR3cjxxrIlxkzUsMX45zShth2NXBus=";
    packages = nextcloud28Packages;
  };

  nextcloud29 = generic {
    version = "29.0.0";
    hash = "sha256-6bU/ZDK29mRIfThpZF+hIaZM8O1q7oOqVgkD2vhrUr0=";
    packages = nextcloud29Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
