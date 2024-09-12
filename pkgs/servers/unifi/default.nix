{ lib, stdenv, dpkg, fetchurl, zip, nixosTests }:

let
  generic = { version, sha256, suffix ? "", knownVulnerabilities ? [ ], ... } @ args:
  stdenv.mkDerivation (args // {
    pname = "unifi-controller";

    src = fetchurl {
      url = "https://dl.ubnt.com/unifi/${version}${suffix}/unifi_sysvinit_all.deb";
      inherit sha256;
    };

    nativeBuildInputs = [ dpkg ];

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb -x $src ./
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cd ./usr/lib/unifi
      cp -ar dl lib webapps $out

      runHook postInstall
    '';

    passthru.tests = {
      unifi = nixosTests.unifi;
    };

    meta = with lib; {
      homepage = "http://www.ubnt.com/";
      description = "Controller for Ubiquiti UniFi access points";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.unfree;
      platforms = platforms.unix;
      maintainers = with maintainers; [ globin patryk27 ];
      inherit knownVulnerabilities;
    };
  });

in rec {
  # see https://community.ui.com/releases / https://www.ui.com/download/unifi

  unifi7 = generic {
    version = "7.5.187";
    suffix = "-f57f5bf7ab";
    sha256 = "sha256-a5kl8gZbRnhS/p1imPl7soM0/QSFHdM0+2bNmDfc1mY=";
    knownVulnerabilities = [ "CVE-2024-42025" ];
  };

  unifi8 = generic {
    version = "8.4.59";
    suffix = "-y2b2oj1o96";
    sha256 = "sha256-VwRvU+IHJs6uThdWF0uOqxz4cegBykYzB/fD0/AGPaM=";
  };
}
