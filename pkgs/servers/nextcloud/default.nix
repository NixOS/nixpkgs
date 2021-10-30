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
    version = "21.0.5";
    sha256 = "1q46h480kn97k7h3xm7r5gsa8l3f0kfiicapi46sh0p39pbjbyhv";
  };

  nextcloud22 = generic {
    version = "22.2.0";
    sha256 = "07ryvynws65k42n6ca20nni1vqr90fsrd2dpx2bvh09mwhyblg97";
  };
  # tip: get she sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
