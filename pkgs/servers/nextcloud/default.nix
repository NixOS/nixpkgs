{ lib, stdenv, fetchurl, nixosTests }:

let
  generic = {
    version, sha256,
    eol ? false, extraVulnerabilities ? []
  }: stdenv.mkDerivation rec {
    pname = "nextcloud";
    inherit version;

    src = fetchurl {
      url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
      inherit sha256;
    };

    passthru.tests = nixosTests.nextcloud;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/
      cp -R . $out/
      runHook postInstall
    '';

    meta = with lib; {
      description = "Sharing solution for files, calendars, contacts and more";
      homepage = "https://nextcloud.com";
      maintainers = with maintainers; [ schneefux bachp globin fpletz ma27 ];
      license = licenses.agpl3Plus;
      platforms = with platforms; unix;
      knownVulnerabilities = extraVulnerabilities
        ++ (optional eol "Nextcloud version ${version} is EOL");
    };
  };
in {
  nextcloud20 = throw ''
    Nextcloud v20 has been removed from `nixpkgs` as the support for it was dropped
    by upstream in 2021-10. Please upgrade to at least Nextcloud v21 by declaring

        services.nextcloud.package = pkgs.nextcloud21;

    in your NixOS config.

    WARNING: if you were on Nextcloud 19 on NixOS 21.05 you have to upgrade to Nextcloud 20
    first on 21.05 because Nextcloud doesn't support upgrades accross multiple major versions!
  '';

  nextcloud21 = generic {
    version = "21.0.9";
    sha256 = "sha256-p6bvgTXmmjGN3TRQpG88f3YPksh0QzWG9j9KnEjcrqE=";
  };

  nextcloud22 = generic {
    version = "22.2.8";
    sha256 = "061b8a118d0fa500058a04ff8476ba96d4c24cef56e5fe5e300cc7113ce13a18";
  };

  nextcloud23 = generic {
    version = "23.0.6";
    sha256 = "34fbc3a6c16a623f57971b8c4df7c5e62b3650728edec7d05ec116b295040548";
  };

  nextcloud24 = generic {
    version = "24.0.2";
    sha256 = "30d6cac1265dff221836bec46a937dcafd7e7d52ee59b939841750b514e5033d";
  };

  # tip: get she sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
