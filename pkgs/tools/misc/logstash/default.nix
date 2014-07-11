{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.4.2";
  name = "logstash-${version}";

  src = fetchurl {
    url = "https://download.elasticsearch.org/logstash/logstash/logstash-${version}.tar.gz";
    sha256 = "0sc0bwyf96fzs5h3d7ii65v9vvpfbm7w67vk1im9djnlz0d1ggnm";
  };

  dontBuild    = true;
  dontPatchELF = true;
  dontStrip    = true;

  installPhase = ''
    cp -a bin $out
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    homepage    = http://www.elasticsearch.org;
  };
}
