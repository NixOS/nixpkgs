{
  lib,
  stdenv,
  fetchurl,
  bash,
  makeWrapper,
  jdk21_headless,
  nixosTests,
}:

let
  common =
    {
      version,
      hash,
      # JDK 21 is the latest runtime supported by all currently packaged HBase
      # releases (2.4 through 3.0). This is verified by nixosTests.hbase*, not by
      # upstream docs (which still recommend JDK 17). JDK 23+ is unusable: HBase
      # relies on Hadoop's UserGroupInformation, which calls the removed
      # Subject.getSubject(), so the master fails to start with
      # "UnsupportedOperationException: getSubject is not supported".
      jdk ? jdk21_headless,
      tests,
    }:
    stdenv.mkDerivation rec {
      pname = "hbase";
      inherit version;

      strictDeps = true;
      __structuredAttrs = true;

      src = fetchurl {
        url = "mirror://apache/hbase/${version}/hbase-${version}-bin.tar.gz";
        inherit hash;
      };

      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [ bash ];
      installPhase = ''
        mkdir -p $out
        cp -R * $out
        wrapProgram $out/bin/hbase --set-default JAVA_HOME ${jdk.home} \
          --run "test -d /etc/hadoop-conf && export HBASE_CONF_DIR=\''${HBASE_CONF_DIR-'/etc/hadoop-conf/'}" \
          --set-default HBASE_CONF_DIR "$out/conf/"
      '';

      passthru = { inherit tests jdk; };

      meta = {
        description = "Distributed, scalable, big data store";
        homepage = "https://hbase.apache.org";
        license = lib.licenses.asl20;
        maintainers = with lib.maintainers; [ illustris ];
        platforms = lib.platforms.linux;
      };
    };
in
{
  hbase_2_4 = common {
    version = "2.4.18";
    hash = "sha256-zYrHAxzlPRrRchHGVp3fhQT0BD0+wavZ4cAWncrv+MQ=";
    tests.standalone = nixosTests.hbase_2_4;
  };
  hbase_2_5 = common {
    version = "2.5.16";
    hash = "sha256-CGfJMwg8vPQtKELd3TLXhOdc30oSFtIXYb/EssK2wKg=";
    tests.standalone = nixosTests.hbase_2_5;
  };
  hbase_2_6 = common {
    version = "2.6.7";
    hash = "sha256-jea/y4hxyLbX8s74+24o5U4VTc7f2iZLuBPJ9+/A0uU=";
    tests.standalone = nixosTests.hbase2;
  };
  hbase_3_0 = common {
    version = "3.0.0";
    hash = "sha256-CeyIoA8jjw7GCPpYtzfO761gu3M5vVV+oy6kp6CnllU=";
    tests.standalone = nixosTests.hbase3;
  };
}
