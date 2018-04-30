{ stdenv, dpkg, fetchurl }:

let
  generic = { version, sha256, suffix ? "" }:
  stdenv.mkDerivation rec {
    name = "unifi-controller-${version}";

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

    doConfigure = false;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cd ./usr/lib/unifi
      cp -ar dl lib webapps $out

      runHook postInstall
    '';

    meta = with stdenv.lib; {
      homepage = http://www.ubnt.com/;
      description = "Controller for Ubiquiti UniFi access points";
      license = licenses.unfree;
      platforms = platforms.unix;
      maintainers = with maintainers; [ wkennington ];
    };
  };

in rec {

  # https://help.ubnt.com/hc/en-us/articles/115000441548-UniFi-Current-Controller-Versions

  unifiLTS = generic {
    version = "5.6.36";
    sha256  = "075q7vm56fdsjwh72y2cb1pirl2pxdkvqnhvd3bf1c2n64mvp6bi";
  };

  unifiStable = generic {
    version = "5.7.20";
    sha256  = "1ylj4i5mcv6z9n32275ccdf1rqk74zilqsih3r6xzhm30pxrd8dd";
  };

  unifiTesting = generic {
    version = "5.8.14";
    suffix  = "-7ef9535d1b";
    sha256  = "09gr7zkck6npjhhmd27c9ymyna6anwj3w9v9zjicz9skbrddkccq";
  };
}
