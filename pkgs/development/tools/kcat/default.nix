{ lib, stdenv, fetchFromGitHub, pkg-config, zlib, rdkafka, yajl, avro-c, libserdes }:

stdenv.mkDerivation rec {
  pname = "kcat";

  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "kcat";
    rev = version;
    sha256 = "0z3bw00s269myfd1xqksjyznmgp74xfs09xqlq347adsgby3cmfs";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zlib rdkafka yajl avro-c libserdes ];

  preConfigure = ''
    patchShebangs ./configure
  '';

  meta = with lib; {
    description = "A generic non-JVM producer and consumer for Apache Kafka";
    homepage = "https://github.com/edenhill/kcat";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ nyarly ];
  };
}
