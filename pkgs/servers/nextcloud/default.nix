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
  nextcloud19 = throw ''
    Nextcloud v19 has been removed from `nixpkgs` as the support for it was dropped
    by upstream in 2021-06. Please upgrade to at least Nextcloud v20 by
    declaring

        services.nextcloud.package = pkgs.nextcloud20;

    in your NixOS config.
  '';

  nextcloud20 = generic {
    version = "20.0.12";
    sha256 = "sha256-gIIPuWVcWv/5nuXMWticcPBKMjJVsCmvs83tj8fdbgY=";
  };

  nextcloud21 = generic {
    version = "21.0.4";
    sha256 = "sha256-Sg0w/r+6UxGLqZCgwtLBZ2e3eqZ2r8k30gGNaGXF/jo=";
  };

  nextcloud22 = generic {
    version = "22.1.1";
    sha256 = "sha256-5VtuuXf7U5CB4zp9jxluOEMOszfMdr8DeaZjpJf73ls=";
  };
  # tip: get she sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
