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
  nextcloud22 = throw ''
    Nextcloud v22 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2022-07. Please upgrade to at least Nextcloud v23 by declaring

        services.nextcloud.package = pkgs.nextcloud23;

    in your NixOS config.

    WARNING: if you were on Nextcloud 21 on NixOS 21.11 you have to upgrade to Nextcloud 22
    first on 21.11 because Nextcloud doesn't support upgrades accross multiple major versions!
  '';

  nextcloud23 = generic {
    version = "23.0.7";
    sha256 = "89a53d3447d1dcb7ea382d18accf52223040336d08899f0b7568c6dd8a36cd50";
  };

  nextcloud24 = generic {
    version = "24.0.3";
    sha256 = "320c81f9b902922b4bcef3eacf858596a14347fd45bddd26dac198562d212439";
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
