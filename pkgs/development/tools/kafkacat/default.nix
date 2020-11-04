{ stdenv, fetchFromGitHub, pkgconfig, zlib, rdkafka, yajl }:

stdenv.mkDerivation rec {
  pname = "kafkacat";

  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "kafkacat";
    rev = version;
    sha256 = "0z3bw00s269myfd1xqksjyznmgp74xfs09xqlq347adsgby3cmfs";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib rdkafka yajl ];

  preConfigure = ''
    patchShebangs ./configure
  '';

  meta = with stdenv.lib; {
    description = "A generic non-JVM producer and consumer for Apache Kafka";
    homepage = "https://github.com/edenhill/kafkacat";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ nyarly ];
  };
}
