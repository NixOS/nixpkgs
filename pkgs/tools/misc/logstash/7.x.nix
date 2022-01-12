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
      x86_64-linux  = "1vm53alq9q1qy2jcsjg9z339xrkac5r9qqpdafp53ny4zsv1n7vj";
      x86_64-darwin = "0hhjyl04h3gd66rdk22272rj419br4v2i59lyrmaj6hmnsqbv968";
      aarch64-linux = "0yjaki7gjffrz86hvqgn1gzhd9dc9llcj50g2x1sgpyn88zk0z0p";
    }
    else {
      x86_64-linux  = "1f3659vcgczm7v03q3fvsmp1ndp6wm3i7r2b2vbl4xq7hf9v7azk";
      x86_64-darwin = "10zw9qc0lc0x9in0nkxc1aiazhyd69l8sya2ni46ivyyjwf0sqsn";
      aarch64-linux = "1czhgmky2zf3mqykn5ww4257yfhd36mi4x6dq569ymly83pivf8v";
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
