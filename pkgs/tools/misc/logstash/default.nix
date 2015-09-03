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
    mkdir -p $out/bin
    mkdir -p $out/vendor
    mkdir -p $out/lib
    cp -a bin $out
    cp -a vendor $out
    cp -a lib $out
    cp Gemfile* $out
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    homepage    = http://www.elasticsearch.org;
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.wjlroe ];
  };
}
