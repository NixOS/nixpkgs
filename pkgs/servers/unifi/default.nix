{ lib, stdenv, dpkg, fetchurl, zip, nixosTests }:

let
  generic = { version, sha256, suffix ? "", ... } @ args:
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
      maintainers = with maintainers; [ erictapen globin patryk27 pennae ];
    };
  });

in rec {
  # see https://community.ui.com/releases / https://www.ui.com/download/unifi

  unifiLTS = generic {
    version = "5.6.42";
    sha256 = "0wxkv774pw43c15jk0sg534l5za4j067nr85r5fw58iar3w2l84x";
  };

  unifi5 = generic {
    version = "5.14.23";
    sha256 = "1aar05yjm3z5a30x505w4kakbyz35i7mk7xyg0wm4ml6h94d84pv";

    postInstall = ''
      # Remove when log4j is updated to 2.12.2 or 2.16.0.
      ${zip}/bin/zip -q -d $out/lib/log4j-core-*.jar org/apache/logging/log4j/core/lookup/JndiLookup.class
    '';
  };

  unifi6 = generic {
    version = "6.5.55";
    sha256 = "sha256-NUGRO+f6JzWvYPwiitZsgp+LQwnGSncnost03mgNVxA=";
  };

  unifi7 = generic {
    version = "7.3.76";
    sha256 = "sha256-/g/gCAhCT+8eyYDiIkF8WnTIWgEzneiAYHXj1pYj/dA=";
  };
}
