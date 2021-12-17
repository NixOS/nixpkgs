{ lib, stdenv, dpkg, fetchurl }:

let
  generic = { version, sha256, suffix ? "" }:
  stdenv.mkDerivation {
    pname = "unifi-controller";
    inherit version;

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

    meta = with lib; {
      homepage = "http://www.ubnt.com/";
      description = "Controller for Ubiquiti UniFi access points";
      license = licenses.unfree;
      platforms = platforms.unix;
      maintainers = with maintainers; [ erictapen globin patryk27 pennae ];
    };
  };

in rec {
  # see https://community.ui.com/releases / https://www.ui.com/download/unifi

  unifiLTS = generic {
    version = "5.6.42";
    sha256 = "0wxkv774pw43c15jk0sg534l5za4j067nr85r5fw58iar3w2l84x";
  };

  unifi5 = generic {
    version = "5.14.23";
    sha256 = "1aar05yjm3z5a30x505w4kakbyz35i7mk7xyg0wm4ml6h94d84pv";
  };

  unifi6 = generic {
    version = "6.5.55";
    sha256 = "sha256-NUGRO+f6JzWvYPwiitZsgp+LQwnGSncnost03mgNVxA=";
  };
}
