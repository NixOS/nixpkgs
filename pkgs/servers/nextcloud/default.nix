{ lib, stdenvNoCC, fetchurl, nixosTests
, nextcloud27Packages
, nextcloud28Packages
, nextcloud29Packages
, nextcloud30Packages
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
      url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";
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
    version = "27.1.11";
    hash = "sha256-Tt0lcPTINEL48PBhb7d07SZjsRz59upJ55WrQ67vlkU=";
    packages = nextcloud27Packages;
    eol = true;
  };

  nextcloud28 = generic {
    version = "28.0.10";
    hash = "sha256-LoAVJtKJHBhf6sWYXL084pLOcKQl9Tb5GfkBuftMwhA=";
    packages = nextcloud28Packages;
  };

  nextcloud29 = generic {
    version = "29.0.7";
    hash = "sha256-9TL/wxvlqDdLXgcrhv/4dl7Bn9oMhQnO45hzCB2yxUQ=";
    packages = nextcloud29Packages;
  };

  nextcloud30 = generic {
    version = "30.0.0";
    hash = "sha256-GNeoCVe7U+lPsESS9rUhNDTdo+naEtn3iZl2h8hWTmA=";
    packages = nextcloud30Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
