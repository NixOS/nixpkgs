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
      platforms = platforms.linux;
      knownVulnerabilities = extraVulnerabilities
        ++ (optional eol "Nextcloud version ${version} is EOL");
    };
  };
in {
  nextcloud26 = generic {
    version = "26.0.12";
    hash = "sha256-fuTAIAJB9pRfMd0Ewh19FmY0Vj4MuH1iMkkS1BiTI0w=";
    packages = nextcloud26Packages;
  };

  nextcloud27 = generic {
    version = "27.1.7";
    hash = "sha256-hEPi0bsojcQU+q0Kb+/i41uznt0359pcXzTexsDdG+s=";
    packages = nextcloud27Packages;
  };

  nextcloud28 = generic {
    version = "28.0.3";
    hash = "sha256-ntQTwN4W9bAzzu/8ypnA1h/GmNvrjbhRrJrfnu+VGQY=";
    packages = nextcloud28Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
