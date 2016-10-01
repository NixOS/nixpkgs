{ stdenv, fetchurl, makeWrapper, jre  }:

stdenv.mkDerivation rec {
  version = "2.3.4";
  name = "logstash-${version}";

  src = fetchurl {
    url = "https://download.elasticsearch.org/logstash/logstash/logstash-${version}.tar.gz";
    sha256 = "10wm4f5ygzifk84c1n9yyj285ccn2zd2m61y6hyf6wirvhys0qkz";
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
    cp -r {Gemfile*,vendor,lib,bin} $out
	
    wrapProgram $out/bin/logstash \
       --set JAVA_HOME "${jre}"
	   
    wrapProgram $out/bin/rspec \
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
