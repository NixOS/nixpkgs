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
    version = "26.0.13";
    hash = "sha256-CjYt96EjM0j5nRhT/X558GZ7VSwUXcRQEvq1SsMcea4=";
    packages = nextcloud26Packages;
  };

  nextcloud27 = generic {
    version = "27.1.8";
    hash = "sha256-Ciy5vRKCnlOq8XNUPsrQFPCeganXL6YeTEYNhOO47fs=";
    packages = nextcloud27Packages;
  };

  nextcloud28 = generic {
    version = "28.0.4";
    hash = "sha256-m/7O4eEvukjEnppxyqgcS6ELKIR4f6t11kzP0SKhMBk=";
    packages = nextcloud28Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
