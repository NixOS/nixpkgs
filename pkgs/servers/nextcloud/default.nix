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
    version = "20.0.13";
    sha256 = "15mi51aayi3m8brxc0w51mbxp4h3hjv14gr5mm7ch2930x655gg9";
  };

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
