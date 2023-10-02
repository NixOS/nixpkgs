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
  hashes =
    if enableUnfree
    then {
      x86_64-linux  = "sha512-U5G/7wnEA6NlUYo6jo8HW7eXSxNwlbPH/SoBc8+m29SnRRFwo2V6/vPmpGjpCjjW56W2aXmYePk4n6RP+P7gJg==";
      x86_64-darwin = "sha512-jjUWuCMppHUFNY+36rSGyjlCOtxEofBhw19roiWsLzczDyr8PjfrZStlNuXKNdd6wkhd7HQ/qNmd1PzGC928IQ==";
      aarch64-linux = "sha512-BvkaWqv/D4akFQ3mwf0C+20KRLBKxmBZfLTINWzx0iVSqqd4mdtCpJpeNbPK1zvl17rYys+0sX5iKUkynN95Gg==";
    }
    else {
      x86_64-linux  = "sha512-uiLExBT0dRU4e7KMxHYSvqWK/5fEB/JXGGPoMXSivvJzYn9l3VMe2DPkBmjHkUSlAdScPsaRwbHE2PsMsSSwUg==";
      x86_64-darwin = "sha512-gal8oGwIb6wz8y6QEk9knV3c4J1kkCECD0NLdbW/9jBl+dyKome3LO3VgQibwk2xISL3Be+Laaz49Z8Rdxy/dw==";
      aarch64-linux = "sha512-ZK20GnobFLIdRjszPz9EcKTbkUDiiNN5v3lRDIMJHVyifpl5YddXzuIym4XRbabaihA4oArqux50q4+VuEGtCg==";
    };
  this = stdenv.mkDerivation rec {
    version = elk7Version;
    pname = "logstash${lib.optionalString (!enableUnfree) "-oss"}";


    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/logstash/${pname}-${version}-${plat}-${arch}.tar.gz";
      hash = hashes.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
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
      license = if enableUnfree then licenses.elastic20 else licenses.asl20;
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
