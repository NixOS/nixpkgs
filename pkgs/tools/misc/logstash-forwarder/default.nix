{ stdenv, fetchgit, go_1_3 }:
stdenv.mkDerivation {
  name = "logstash-forwarder-20141216";
  src = fetchgit {
    url = https://github.com/elasticsearch/logstash-forwarder.git;
    rev = "6082bd8aaecb2180f5b56f4fb1b2940a6935ef7b";
    sha256 = "1686rlx5p7d2806cg8y4376m4l7nvg1yjgg52ccrs0v4fnqs6292";
  };
  buildInputs = [ go_1_3 ];
  installPhase = ''
    mkdir -p $out/bin
    cp build/bin/logstash-forwarder $out/bin
  '';

  meta = {
    license = stdenv.lib.licenses.asl20;
    homepage = https://github.com/elasticsearch/logstash-forwarder;
    platforms = stdenv.lib.platforms.unix;
  };
}
