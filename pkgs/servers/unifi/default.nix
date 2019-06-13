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
      maintainers = with maintainers; [ erictapen ];
    };
  };

in rec {

  # https://help.ubnt.com/hc/en-us/articles/115000441548-UniFi-Current-Controller-Versions

  unifiLTS = generic {
    version = "5.6.42";
    sha256  = "0wxkv774pw43c15jk0sg534l5za4j067nr85r5fw58iar3w2l84x";
  };

  unifiStable = generic {
    version = "5.10.23";
    sha256  = "0ak8crx3anxsx4r3b9k0rihgafkgsxj7f64z48nrk1l8m7f0wwxg";
  };

  unifiTesting = generic {
    version = "5.11.18";
    suffix = "-996baf2ca5";
    sha256 = "14yyfn39ix8bnn0cb6bn0ly6pqxg81lvy83y40bk0y8vxfg6maqc";
  };
}
