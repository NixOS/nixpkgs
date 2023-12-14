{ lib, stdenvNoCC, fetchurl, nixosTests
, nextcloud27Packages
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
  nextcloud25 = throw ''
    Nextcloud v25 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2023-10. Please upgrade to at least Nextcloud v26 by declaring

        services.nextcloud.package = pkgs.nextcloud26;

    in your NixOS config.

    WARNING: if you were on Nextcloud 24 you have to upgrade to Nextcloud 25
    first on 23.05 because Nextcloud doesn't support upgrades across multiple major versions!
  '';

  nextcloud26 = generic {
    version = "26.0.9";
    hash = "sha256-nVD8a+jjZXyfXrhEj6Fleofh2p5uq0DvYlXSNTMNiIE=";
    packages = nextcloud26Packages;
  };

  nextcloud27 = generic {
    version = "27.1.4";
    hash = "sha256-vsZfIWa4LJMDuvR2weQk9xqhltrQEP/kwMOdA5kNWUw=";
    packages = nextcloud27Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
