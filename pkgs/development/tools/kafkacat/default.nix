{ stdenv, fetchFromGitHub, pkgconfig, zlib, rdkafka, yajl }:

stdenv.mkDerivation rec {
  pname = "kafkacat";

  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "kafkacat";
    rev = version;
    sha256 = "0lf2pf3zqncd4a44h0mjm66qnw02k9kvz1hjkah6p6gp7mx3ksjv";
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
