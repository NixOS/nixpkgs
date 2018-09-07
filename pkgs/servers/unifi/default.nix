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
    version = "5.6.39";
    sha256  = "025qq517j32r1pnabg2q8lhy65c6qsk17kzw3aijhrc2gpgj2pa7";
  };

  unifiStable = generic {
    version = "5.8.28";
    sha256  = "1zyc6n54dwqy9diyqnzlwypgnj3hqcv0lfx47s4rkq3kbm49nwnl";
  };

  unifiTesting = generic {
    version = "5.9.22";
    suffix  = "-d2a4718971";
    sha256  = "1xxpvvn0815snag4bmmsdm8zh0cb2qjrhnvlkgn8i478ja1r3n54";
  };
}
