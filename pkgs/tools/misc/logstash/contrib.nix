{
  stdenv,
  lib,
  fetchzip,
}:

# Note that plugins are supposed to be installed as:
#   $path/logstash/{inputs,codecs,filters,outputs}/*.rb
stdenv.mkDerivation rec {
  version = "1.4.2";
  pname = "logstash-contrib";

  src = fetchzip {
    url = "https://download.elasticsearch.org/logstash/logstash/logstash-contrib-${version}.tar.gz";
    sha256 = "1yj8sf3b526gixh3c6zhgkfpg4f0c72p1lzhfhdx8b3lw7zjkj0k";
  };

  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;
  dontPatchShebangs = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/logstash
    cp -r lib/* $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Community-maintained logstash plugins";
    homepage = "https://github.com/elasticsearch/logstash-contrib";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
