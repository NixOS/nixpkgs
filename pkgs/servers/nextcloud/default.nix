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
    version = "22.2.7";
    sha256 = "5ada41cb3e69665e8a13946f71978829c0a0163d0277a49e599c9e8ccf960eab";
  };

  nextcloud23 = generic {
    version = "23.0.4";
    sha256 = "67191c2b8b41591ae42accfb32216313fde0e107201682cb39029f890712bc6a";
  };

  nextcloud24 = generic {
    version = "24.0.0";
    sha256 = "176cb5620f20465fb4759bdf3caaebeb7acff39d6c8630351af9f8738c173780";
  };

  # tip: get she sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
