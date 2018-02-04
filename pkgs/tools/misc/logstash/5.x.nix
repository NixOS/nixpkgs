{ stdenv, fetchurl, elk5Version, makeWrapper, jre  }:

stdenv.mkDerivation rec {
  version = elk5Version;
  name = "logstash-${version}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/logstash/${name}.tar.gz";
    sha256 = "0cpim121ydxdjr251by9jw6pidh5b52jl5ldcm7gp015q49x1nl7";
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

    wrapProgram $out/bin/logstash \
       --set JAVA_HOME "${jre}"

    wrapProgram $out/bin/logstash-plugin \
       --set JAVA_HOME "${jre}"
  '';

  meta = with stdenv.lib; {
    description = "Logstash is a data pipeline that helps you process logs and other event data from a variety of systems";
    homepage    = https://www.elastic.co/products/logstash;
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = [ maintainers.wjlroe maintainers.offline ];
  };
}
