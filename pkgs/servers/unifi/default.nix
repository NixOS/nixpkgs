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
    version = "5.9.29";
    sha256  = "0djdjh7lwaa5nvhvz2yh6dn07iad5nq4jpab7rc909sljl6wvwvx";
  };

  unifiTesting = unifiStable;
}
