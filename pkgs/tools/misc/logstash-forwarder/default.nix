{ stdenv, fetchgit, go_1_1 }:
stdenv.mkDerivation {
  name = "logstash-forwarder-20140410";
  src = fetchgit {
    url = https://github.com/elasticsearch/logstash-forwarder.git;
    rev = "ec504792108ab6536b45bcf6dff6d26a6b56fef3";
    sha256 = "309545ceaec171bee997cad260bef1433e041b9f3bfe617d475bcf79924f943d";
  };
  buildInputs = [ go_1_1 ];
  installPhase = ''
    mkdir -p $out/bin
    cp build/bin/logstash-forwarder $out/bin
  '';

  meta = {
    license = stdenv.lib.licenses.asl20;
    homepage = https://github.com/elasticsearch/logstash-forwarder;
    platforms = stdenv.lib.platforms.linux;
  };
}
