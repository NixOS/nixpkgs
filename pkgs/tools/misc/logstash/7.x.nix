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
      x86_64-linux  = "0yjaki7gjffrz86hvqgn1gzhd9dc9llcj50g2x1sgpyn88zk0z0p";
      x86_64-darwin = "0dqm66c89w1nvmbwqzphlqmf7avrycgv1nwd5b0k1z168fj0c3zm";
      aarch64-linux = "11hjhyb48mjagmvqyxb780n57kr619h6p4adl2vs1zm97g9gslx8";
    }
    else {
      x86_64-linux  = "14b1649avjcalcsi0ffkgznq6d93qdk6m3j0i73mwfqka5d3dvy3";
      x86_64-darwin = "0ypgdfklr5rxvsnc3czh231pa1z2h70366j1c6q5g64b3xnxpphs";
      aarch64-linux = "01ainayr8fwwfix7dmxfhhmb23ji65dn4lbjwnj2w0pl0ym9h9w2";
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
