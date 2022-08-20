{ elk7Version
, enableUnfree ? true
, lib
, stdenv
, fetchurl
, makeWrapper
, nixosTests
, jre
}:

with lib;

let
  info = splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas =
    if enableUnfree
    then {
      x86_64-linux  = "35e50e05fba0240aa5b138bc1c81f67addaf557701f8df41c682b5bc708f7455";
      x86_64-darwin = "698b6000788e123b647c988993f710c6d9bc44eb8c8e6f97d6b18a695a61f0a6";
      aarch64-linux = "69694856fde11836eb1613bf3a2ba31fbdc933f58c8527b6180f6122c8bb528b";
    }
    else {
      x86_64-linux  = "3a2da2e63bc08ee1886db29c80103c669d3ed6960290b8b97d771232769f282e";
      x86_64-darwin = "655ab873e16257827f884f67b66d62c4da40a895d06206faa435615ad0a56796";
      aarch64-linux = "235cf57afb619801808d5fe1bff7e01a4a9b29f77723566e5371b5f3b2bf8fad";
    };
  this = stdenv.mkDerivation rec {
    version = elk7Version;
    pname = "logstash${optionalString (!enableUnfree) "-oss"}";


    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/logstash/${pname}-${version}-${plat}-${arch}.tar.gz";
      sha256 = shas.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
    };

    dontBuild = true;
    dontPatchELF = true;
    dontStrip = true;
    dontPatchShebangs = true;

    nativeBuildInputs = [
      makeWrapper
    ];

    buildInputs = [
      jre
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r {Gemfile*,modules,vendor,lib,bin,config,data,logstash-core,logstash-core-plugin-api} $out

      patchShebangs $out/bin/logstash
      patchShebangs $out/bin/logstash-plugin

      wrapProgram $out/bin/logstash \
         --set JAVA_HOME "${jre}"

      wrapProgram $out/bin/logstash-plugin \
         --set JAVA_HOME "${jre}"
      runHook postInstall
    '';

    meta = with lib; {
      description = "Logstash is a data pipeline that helps you process logs and other event data from a variety of systems";
      homepage = "https://www.elastic.co/products/logstash";
      sourceProvenance = with sourceTypes; [
        fromSource
        binaryBytecode  # source bundles dependencies as jars
        binaryNativeCode  # bundled jruby includes native code
      ];
      license = if enableUnfree then licenses.elastic else licenses.asl20;
      platforms = platforms.unix;
      maintainers = with maintainers; [ wjlroe offline basvandijk ];
    };
    passthru.tests =
      optionalAttrs (!enableUnfree) (
        assert this.drvPath == nixosTests.elk.ELK-7.elkPackages.logstash.drvPath;
        {
          elk = nixosTests.elk.ELK-7;
        }
      );
  };
in
this
