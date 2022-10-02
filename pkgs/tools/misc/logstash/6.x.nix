{ elk6Version
, enableUnfree ? true
, lib, stdenv
, fetchurl
, makeWrapper
, nixosTests
, jre
}:

with lib;

let this = stdenv.mkDerivation rec {
  version = elk6Version;
  pname = "logstash${optionalString (!enableUnfree) "-oss"}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/logstash/${pname}-${version}.tar.gz";
    sha256 =
      if enableUnfree
      then "0hij1byw5b3xmk3vshr9p7gxwbjrywr7ylps05ydc2dmnz8q2a79"
      else "1fa236pvhj7spys54nqi3k64rwzf6zi6gaccmqg4p4sh92jzsybv";
  };

  dontBuild         = true;
  dontPatchELF      = true;
  dontStrip         = true;
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
    description = "A data pipeline that helps you process logs and other event data from a variety of systems";
    homepage    = "https://www.elastic.co/products/logstash";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # source bundles dependencies as jars
      binaryNativeCode  # bundled jruby includes native code
    ];
    license     = if enableUnfree then licenses.elastic else licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ wjlroe offline basvandijk ];
  };
  passthru.tests =
    optionalAttrs (!enableUnfree) (
      assert this.drvPath == nixosTests.elk.ELK-6.elkPackages.logstash.drvPath;
      {
        elk = nixosTests.elk.ELK-6;
      }
    );
};
in this
