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
      maintainers = with maintainers; [ schneefux bachp globin ma27 ];
      license = licenses.agpl3Plus;
      platforms = with platforms; unix;
      knownVulnerabilities = extraVulnerabilities
        ++ (optional eol "Nextcloud version ${version} is EOL");
    };
  };
in {
  nextcloud23 = throw ''
    Nextcloud v23 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2022-12. Please upgrade to at least Nextcloud v24 by declaring

        services.nextcloud.package = pkgs.nextcloud24;

    in your NixOS config.

    WARNING: if you were on Nextcloud 22 on NixOS 22.05 you have to upgrade to Nextcloud 23
    first on 22.05 because Nextcloud doesn't support upgrades accross multiple major versions!
  '';

  nextcloud24 = generic {
    version = "24.0.7";
    sha256 = "a1c7344a4eb27260a9f6f6e6f586bdc4fb35e1e9330e1a6e8d46c05634db6384";
  };

  nextcloud25 = generic {
    version = "25.0.1";
    sha256 = "72d4076924caf19139c40178597af6211799e20440ce196fb43b9c4e47d77515";
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
