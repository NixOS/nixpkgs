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
      x86_64-linux = "sha256-5qv4fbFpLf6aduD7wyxXQ6FsCeUqrszRisNBx44vbMY=";
      x86_64-darwin = "sha256-7H+Xpo8qF1ZZMkR5n92PVplEN4JsBEYar91zHQhE+Lo=";
    }
    else {
      x86_64-linux = "sha256-jiV2yGPwPgZ5plo3ftImVDLSOsk/XBzFkeeALSObLhU=";
      x86_64-darwin = "sha256-UYG+GGr23eAc2GgNX/mXaGU0WKMjiQMPpD1wUvAVz0A=";
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

    buildInputs = [
      makeWrapper
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
