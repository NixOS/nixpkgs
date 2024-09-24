{ lib, stdenvNoCC, fetchurl, nixosTests
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

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
