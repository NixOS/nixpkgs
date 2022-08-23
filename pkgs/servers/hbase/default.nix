{ lib
, stdenv
, fetchurl
, makeWrapper
, jdk8_headless
, jdk11_headless
, nixosTests
}:

let common = { version, hash, jdk ? jdk11_headless, tests }:
  stdenv.mkDerivation rec {
    pname = "hbase";
    inherit version;

    src = fetchurl {
      url = "mirror://apache/hbase/${version}/hbase-${version}-bin.tar.gz";
      inherit hash;
    };

    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out
      cp -R * $out
      wrapProgram $out/bin/hbase --set-default JAVA_HOME ${jdk.home} \
        --run "test -d /etc/hadoop-conf && export HBASE_CONF_DIR=\''${HBASE_CONF_DIR-'/etc/hadoop-conf/'}" \
        --set-default HBASE_CONF_DIR "$out/conf/"
    '';

    passthru = { inherit tests; };

    meta = with lib; {
      description = "A distributed, scalable, big data store";
      homepage = "https://hbase.apache.org";
      license = licenses.asl20;
      maintainers = with lib.maintainers; [ illustris ];
      platforms = lib.platforms.linux;
    };
  };
in
{
  hbase_1_7 = common {
    version = "1.7.1";
    hash = "sha256-DrH2G79QLT8L0YTTmAGC9pUWU8semSaTOsrsQRCI2rY=";
    jdk = jdk8_headless;
    tests.standalone = nixosTests.hbase1;
  };
  hbase_2_4 = common {
    version = "2.4.11";
    hash = "sha256-m0vjUtPaj8czHHh+rQNJJgrFAM744cHd06KE0ut7QeU=";
    tests.standalone = nixosTests.hbase2;
  };
  hbase_3_0 = common {
    version = "3.0.0-alpha-2";
    hash = "sha256-QPvgO1BeFWvMT5PdUm/SL92ZgvSvYIuJbzolbBTenz4=";
    tests.standalone = nixosTests.hbase3;
  };
}
