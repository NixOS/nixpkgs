{ fetchurl, stdenv, version ? "2.6.0" }:

let
  versionMap = {
    "2.6.0" = {
      sha512 = "6c86a31ef6a9ffac2fb6830026d8d522e561a8cfbd5caed463ed78aa4de98829cf6e35ec7e7f65e99a8f3282d7cbf7a2bbc32a81d6d431e02f8bec445aed9552";
    };
  };

  sha512 = versionMap.${version}.sha512;
in
  stdenv.mkDerivation {
    name = "apache-pulsar";

    src = fetchurl {
      url = "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-${version}/apache-pulsar-${version}-bin.tar.gz";
      sha512 = sha512;
    };

    installPhase = ''
      mkdir -p $out
      cp -R * $out
    '';

    meta = with stdenv.lib; {
      homepage = "https://pulsar.apache.org";
      description = "An open source distributed pub-sub messaging system";
      license = licenses.asl20;
      platforms = platforms.unix;
      maintainers = with maintainers; [ lperkins ];
    };
  }
