{ config
, elk7Version
, enableUnfree ? true
, lib
, stdenv
, fetchurl
, makeWrapper
, nixosTests
, jre
}:

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  shas =
    if enableUnfree
    then {
      x86_64-linux  = "a43d592e70f023a594f31a3fba365a9cca6611599bd61f998cb1fc38ddd177d459bce23eaf54f811fe0a87a47cdd4bf4b4d4c8008dab1ac03173371f63b91b6c";
      x86_64-darwin = "7f7d89f438400da178b30f345b6ebc80f55f87f38b8925ca8c9dea86f0e2f23f70ccab03fdef5b83c085f1441e77592aab05006d163bc2af1920e1cc0ebdfc17";
      aarch64-linux = "3c74d622c362e3aa72442a477ef34b0eb9131f5b550166d0f7f422bd3678acf07d75c702691d6606e5501f4b40854a352398d1c2813f1fb0a152663d75d5658b";
    }
    else {
      x86_64-linux  = "7c3f9867853582e5d06b9f895b4740abf56a9b6ce34dfbfb624cf9a4b956f489145cd13f3194a7fb16efc52410f55e797c269dc2957a35bdebf9e1aaa3547eaa";
      x86_64-darwin = "d81c20317a7c163e42f5aad9e148505a64bba8565ff913650a840918b80e6aadde071596e569b0c8f965810b821779ca3d00f9a7cb24a5c86fff571ca9227c38";
      aarch64-linux = "93d9700fc3dd99bc918be19fe41ef60b9071eadcc6fd57833dbf1fff2e0f2419c62f3493a0454f215b0dfd30cec90f1aca5eeff15c4eb3a583519dc9a69e896a";
    };
  this = stdenv.mkDerivation rec {
    version = elk7Version;
    pname = "logstash${lib.optionalString (!enableUnfree) "-oss"}";


    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/logstash/${pname}-${version}-${plat}-${arch}.tar.gz";
      sha512 = shas.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
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
      lib.optionalAttrs (config.allowUnfree && enableUnfree) (
        assert this.drvPath == nixosTests.elk.unfree.ELK-7.elkPackages.logstash.drvPath;
        {
          elk = nixosTests.elk.unfree.ELK-7;
        }
      );
  };
in
this
