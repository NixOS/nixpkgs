{ lib, stdenv, fetchFromGitHub, pkg-config, zlib, rdkafka, yajl, avro-c, libserdes, which }:

stdenv.mkDerivation rec {
  pname = "kcat";

  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "kcat";
    rev = version;
    sha256 = "sha256-pCIYNx0GYPGDYzTLq9h/LbOrJjhKWLAV4gq07Ikl5O4=";
  };

  nativeBuildInputs = [ pkg-config which ];

  buildInputs = [ zlib rdkafka yajl avro-c libserdes ];

  meta = with lib; {
    description = "Generic non-JVM producer and consumer for Apache Kafka";
    mainProgram = "kcat";
    homepage = "https://github.com/edenhill/kcat";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ nyarly ];
  };
}
