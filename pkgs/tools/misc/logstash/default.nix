{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.5.3";
  name = "logstash-${version}";

  src = fetchurl {
    url = "https://download.elasticsearch.org/logstash/logstash/logstash-${version}.tar.gz";
    sha256 = "1an476k4q2shdxvhcx4fzbrcpk6isjrrvzlb6ivxfqg5fih3cg7b";
  };

  dontBuild         = true;
  dontPatchELF      = true;
  dontStrip         = true;
  dontPatchShebangs = true;

  installPhase = ''
    mkdir -p $out
    cp -r {Gemfile*,vendor,lib,bin} $out
    mv $out/bin/plugin $out/bin/logstash-plugin
  '';

  meta = with stdenv.lib; {
    description = "Logstash is a data pipeline that helps you process logs and other event data from a variety of systems";
    homepage    = https://www.elastic.co/products/logstash;
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = [ maintainers.wjlroe maintainers.offline ];
  };
}
