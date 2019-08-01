{ stdenv, fetchFromGitHub, pkgconfig, zlib, rdkafka, yajl }:

stdenv.mkDerivation rec {
  name = "kafkacat-${version}";

  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "kafkacat";
    rev = "${version}";
    sha256 = "0zs2nmf3ghm9iar7phc0ncqsb9nhipav94v6qmpxkfwxd2ljkpds";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib rdkafka yajl ];

  preConfigure = ''
    patchShebangs ./configure
  '';

  meta = with stdenv.lib; {
    description = "A generic non-JVM producer and consumer for Apache Kafka";
    homepage = https://github.com/edenhill/kafkacat;
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ nyarly ];
  };
}
