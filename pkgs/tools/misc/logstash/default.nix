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
  dontPatchShebangs = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/vendor
    mkdir -p $out/lib
    mkdir -p $out/locales
    mkdir -p $out/patterns
    cp -a bin $out
    cp -a vendor $out
    cp -a lib $out
    cp -a locales $out
    cp -a patterns $out
    patchShebangs $out/bin
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    homepage    = http://www.elasticsearch.org;
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.wjlroe ];
  };
}
