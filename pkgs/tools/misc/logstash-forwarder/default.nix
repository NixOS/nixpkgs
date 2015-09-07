{ stdenv, fetchFromGitHub, go }:

stdenv.mkDerivation rec {
  name = "logstash-forwarder-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "elasticsearch";
    repo = "logstash-forwarder";
    rev = "v${version}";
    sha256 = "05g7366w8f7h75n1ia7njdpmparr6sfvn45xxfh5412zigqidz6l";
  };

  buildInputs = [ go ];

  installPhase = ''
    mkdir -p $out/bin
    find . -name logstash-forwarder -type f -exec cp {} $out/bin \;
  '';

  meta = {
    license = stdenv.lib.licenses.asl20;
    homepage = https://github.com/elasticsearch/logstash-forwarder;
    platforms = stdenv.lib.platforms.unix;
  };
}
