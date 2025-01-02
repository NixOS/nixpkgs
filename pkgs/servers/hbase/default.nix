{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk11_headless,
  nixosTests,
}:

let
  common =
    {
      version,
      hash,
      jdk ? jdk11_headless,
      tests,
    }:
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
        description = "Distributed, scalable, big data store";
        homepage = "https://hbase.apache.org";
        license = licenses.asl20;
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
    version = "2.5.10";
    hash = "sha256-uYc5IZGQdLOm5gAEyyGtJtcgf+GxADEEuxjixZbG3Qs=";
    tests.standalone = nixosTests.hbase_2_5;
  };
  hbase_2_6 = common {
    version = "2.6.1";
    hash = "sha256-dubu/4Ilk82NtNEcKt8uLbcH8n81EncxOvkZOwk2kVA=";
    tests.standalone = nixosTests.hbase2;
  };
  hbase_3_0 = common {
    version = "3.0.0-beta-1";
    hash = "sha256-lmeaH2gDP6sBwZpzROKhR2Je7dcrwnq7qlMUh0B5fZs=";
    tests.standalone = nixosTests.hbase3;
  };
}
