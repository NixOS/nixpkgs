{ elk6Version
, enableUnfree ? true
, stdenv
, fetchurl
, makeWrapper
, jre
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = elk6Version;
  name = "logstash-${optionalString (!enableUnfree) "oss-"}${version}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/logstash/${name}.tar.gz";
    sha256 =
      if enableUnfree
      then "00pwi7clgdflzzg15bh3y30gzikvvy7p5fl88fww7xhhy47q8053"
      else "0spxgqsyh72n0l0xh6rljp0lbqz46xmr02sqz25ybycr4qkxdhgk";
  };

  dontBuild         = true;
  dontPatchELF      = true;
  dontStrip         = true;
  dontPatchShebangs = true;

  buildInputs = [
    makeWrapper jre
  ];

  installPhase = ''
    mkdir -p $out
    cp -r {Gemfile*,modules,vendor,lib,bin,config,data,logstash-core,logstash-core-plugin-api} $out

    patchShebangs $out/bin/logstash
    patchShebangs $out/bin/logstash-plugin

    wrapProgram $out/bin/logstash \
       --set JAVA_HOME "${jre}"

    wrapProgram $out/bin/logstash-plugin \
       --set JAVA_HOME "${jre}"
  '';

  meta = with stdenv.lib; {
    description = "Logstash is a data pipeline that helps you process logs and other event data from a variety of systems";
    homepage    = https://www.elastic.co/products/logstash;
    license     = if enableUnfree then licenses.elastic else licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ wjlroe offline basvandijk ];
  };
}
