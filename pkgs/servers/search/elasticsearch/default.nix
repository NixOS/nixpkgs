{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "elasticsearch-0.20.5";

  src = fetchurl {
    url = "https://download.elasticsearch.org/elasticsearch/elasticsearch/${name}.tar.gz";
    sha256 = "0r0h9znyflajps1k8hl9naixhg1gqmhz7glc009pzzv94ncdzrq1";
  };

  patches = [ ./es-home.patch ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib $out
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = "ASL2.0";
  };
}
