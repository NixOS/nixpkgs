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

    patches = [ ./0001-Setup-remove-custom-dbuser-creation-behavior.patch ];

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
  nextcloud22 = throw ''
    Nextcloud v22 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2022-07. Please upgrade to at least Nextcloud v23 by declaring

        services.nextcloud.package = pkgs.nextcloud23;

    in your NixOS config.

    WARNING: if you were on Nextcloud 21 on NixOS 21.11 you have to upgrade to Nextcloud 22
    first on 21.11 because Nextcloud doesn't support upgrades accross multiple major versions!
  '';

  nextcloud23 = generic {
    version = "23.0.9";
    sha256 = "sha256-Ysxapp8IpRcRBC3CRM4yxoGYCuedAVURT3FhDD4jNBY=";
  };

  nextcloud24 = generic {
    version = "24.0.5";
    sha256 = "sha256-sieIN3zLk5Hn+eztP2mpI2Zprqqy4OpSUKc+318e8CY=";
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
