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
    version = "22.2.6";
    sha256 = "0f1d0f0cb000c51b11886be25a8adce478846c3233572fcf28b44c5d4036e235";
  };

  nextcloud23 = generic {
    version = "23.0.3";
    sha256 = "39401d400fab02a84a175ea6e995b8ed4110fbaea48c876230b4f09755a62986";
  };
  # tip: get she sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
