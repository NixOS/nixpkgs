{ stdenv, lib, fetchzip }:

# Note that plugins are supposed to be installed as:
#   $path/logstash/{inputs,codecs,filters,outputs}/*.rb 
stdenv.mkDerivation rec {
  version = "1.4.2";
  name = "logstash-contrib-${version}";

  src = fetchzip {
   url = "http://download.elasticsearch.org/logstash/logstash/logstash-contrib-${version}.tar.gz";
   sha256 = "1yj8sf3b526gixh3c6zhgkfpg4f0c72p1lzhfhdx8b3lw7zjkj0k";
  };

  dontBuild    = true;
  dontPatchELF = true;
  dontStrip    = true;
  dontPatchShebangs = true;

  installPhase = ''
    mkdir -p $out/logstash
    cp -r lib/* $out
  '';

  meta = with lib; {
    description = "Community-maintained logstash plugins";
    homepage    = https://github.com/elasticsearch/logstash-contrib;
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ cstrahan ];
  };
}
