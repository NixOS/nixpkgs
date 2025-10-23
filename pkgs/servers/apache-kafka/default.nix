{
  lib,
  stdenv,
  fetchurl,
  jdk17_headless,
  makeWrapper,
  bash,
  coreutils,
  gnugrep,
  gnused,
  ps,
  nixosTests,
}:

let
  versionMap = {
    "4_1" = {
      kafkaVersion = "4.1.0";
      scalaVersion = "2.13";
      sha256 = "sha256-hbRThHDR3LmNAnMoa/q4cXBlUi5Zfs//zU24OjAhdY4=";
      jre = jdk17_headless;
      nixosTest = nixosTests.kafka.base.kafka_4_1;
    };
    "4_0" = {
      kafkaVersion = "4.0.0";
      scalaVersion = "2.13";
      sha256 = "sha256-e4Uuk4vAneEM2W7KN1UljH0l+4nb3XYwVxdgfhg14qo=";
      jre = jdk17_headless;
      nixosTest = nixosTests.kafka.base.kafka_4_0;
    };
    "3_9" = {
      kafkaVersion = "3.9.1";
      scalaVersion = "2.13";
      sha256 = "sha256-3UOZgW5niUbKt2470WhhA1VeabyPKrhobNpxqhW8MaM=";
      jre = jdk17_headless;
      nixosTest = nixosTests.kafka.base.kafka_3_9;
    };
  };

  build =
    versionInfo:
    stdenv.mkDerivation rec {
      version = "${versionInfo.scalaVersion}-${versionInfo.kafkaVersion}";
      pname = "apache-kafka";

      src = fetchurl {
        url = "mirror://apache/kafka/${versionInfo.kafkaVersion}/kafka_${version}.tgz";
        inherit (versionInfo) sha256;
      };

      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [
        versionInfo.jre
        bash
        gnugrep
        gnused
        coreutils
        ps
      ];

      installPhase = ''
        mkdir -p $out
        cp -R config libs $out

        mkdir -p $out/bin
        cp bin/kafka* $out/bin
        cp bin/connect* $out/bin

        # allow us the specify logging directory using env
        substituteInPlace $out/bin/kafka-run-class.sh \
          --replace 'LOG_DIR="$base_dir/logs"' 'LOG_DIR="$KAFKA_LOG_DIR"'

        substituteInPlace $out/bin/kafka-server-stop.sh \
          --replace 'ps' '${ps}/bin/ps'

        for p in $out/bin\/*.sh; do
          wrapProgram $p \
            --set JAVA_HOME "${versionInfo.jre}" \
            --set KAFKA_LOG_DIR "/tmp/apache-kafka-logs" \
            --prefix PATH : "${bash}/bin:${coreutils}/bin:${gnugrep}/bin:${gnused}/bin"
        done
        chmod +x $out/bin\/*
      '';

      passthru = {
        inherit (versionInfo) jre; # Used by the NixOS module to select the supported JRE
        tests.nixos = versionInfo.nixosTest;
      };

      meta = {
        homepage = "https://kafka.apache.org";
        description = "High-throughput distributed messaging system";
        license = lib.licenses.asl20;
        sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
        maintainers = [ lib.maintainers.ragge ];
        platforms = lib.platforms.unix;
      };
    };
in
lib.mapAttrs' (
  majorVersion: versionInfo: lib.nameValuePair "apacheKafka_${majorVersion}" (build versionInfo)
) versionMap
