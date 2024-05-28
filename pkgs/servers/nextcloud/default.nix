{ lib, stdenvNoCC, fetchurl, nixosTests
, nextcloud27Packages
, nextcloud28Packages
, nextcloud29Packages
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
  nextcloud25 = throw ''
    Nextcloud v25 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2023-10. Please upgrade to at least Nextcloud v26 by declaring

        services.nextcloud.package = pkgs.nextcloud26;

    in your NixOS config.

    WARNING: if you were on Nextcloud 24 you have to upgrade to Nextcloud 25
    first on 23.05 because Nextcloud doesn't support upgrades across multiple major versions!
  '';

  nextcloud26 = generic {
    version = "26.0.13";
    hash = "sha256-CjYt96EjM0j5nRhT/X558GZ7VSwUXcRQEvq1SsMcea4=";
    packages = nextcloud26Packages;
  };

  nextcloud27 = generic {
    version = "27.1.9";
    hash = "sha256-+P4QzLWFNJ+EUQ25tLAgjbfziV2vPXpejxfSNuzEEfU=";
    packages = nextcloud27Packages;
  };

  nextcloud28 = generic {
    version = "28.0.6";
    hash = "sha256-3w0zhLRHy6HhKPIggPZ4BSH4aBab6r7o6g0VW/nGa48=";
    packages = nextcloud28Packages;
  };

  nextcloud29 = generic {
    version = "29.0.1";
    hash = "sha256-dZVG2uz3nKeH7WcFUDaTxttVOqvx165N+neccwmyrak=";
    packages = nextcloud29Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
