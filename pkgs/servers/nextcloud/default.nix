{ lib, stdenv, fetchurl, nixosTests }:

let
  generic = {
    version, sha256,
    eol ? false, extraVulnerabilities ? []
  }: let
    major = lib.versions.major version;
  in stdenv.mkDerivation rec {
    pname = "nextcloud";
    inherit version;

    src = fetchurl {
      url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
      inherit sha256;
    };

    # This patch is only necessary for NC version <26.
    patches = lib.optional (lib.versionOlder major "26") (./patches + "/v${major}/0001-Setup-remove-custom-dbuser-creation-behavior.patch");

    passthru.tests = nixosTests.nextcloud;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/
      cp -R . $out/
      runHook postInstall
    '';

    meta = with lib; {
      changelog = "https://nextcloud.com/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
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
  nextcloud24 = generic {
    version = "24.0.10";
    sha256 = "sha256-B6+0gO9wn39BpcR0IsIuMa81DH8TWuDOlTZR9O1qRbk=";
  };

  nextcloud25 = generic {
    version = "25.0.4";
    sha256 = "sha256-wyUeAIOpQwPi1piLNS87Mwgqeacmsw/3RnCbD+hpoaY=";
  };

  nextcloud26 = generic {
    version = "26.0.0";
    sha256 = "sha256-8WMVA2Ou6TZuy1zVJZv2dW7U8HPOp4tfpRXK2noNDD0=";
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
