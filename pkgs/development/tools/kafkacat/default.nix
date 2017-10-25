{ stdenv, fetchFromGitHub, pkgconfig, zlib, rdkafka, yajl }:

stdenv.mkDerivation rec {
  name = "kafkacat-${version}";

  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "kafkacat";
    rev = "${version}";
    sha256 = "1fgs04rclgfwri6vd9lj0mw545nmscav9p6kh7r28k5ap2g0gak5";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib rdkafka yajl ];

  meta = with stdenv.lib; {
    description = "A generic non-JVM producer and consumer for Apache Kafka";
    homepage = https://github.com/edenhill/kafkacat;
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ nyarly ];
  };
}
