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
  nextcloud21 = throw ''
    Nextcloud v21 has been removed from `nixpkgs` as the support for it was dropped
    by upstream in 2022-02. Please upgrade to at least Nextcloud v22 by declaring

        services.nextcloud.package = pkgs.nextcloud22;

    in your NixOS config.

    WARNING: if you were on Nextcloud 20 on NixOS 21.11 you have to upgrade to Nextcloud 21
    first on 21.11 because Nextcloud doesn't support upgrades accross multiple major versions!
  '';

  nextcloud22 = generic {
    version = "22.2.5";
    sha256 = "sha256-gb5N0u5tu4/nI2xIpjXwm2hiSDCrBhIDyN6gKGOsdS8=";
  };

  nextcloud23 = generic {
    version = "23.0.2";
    sha256 = "sha256-ngJGLTjqq2RX/KgHe9Rv54w6qtRC6RpuEuMvp9UbxO4=";
  };
  # tip: get she sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
