{ lib, stdenv, fetchFromGitHub, pkg-config, zlib, rdkafka, yajl, avro-c, libserdes, which }:

stdenv.mkDerivation rec {
  pname = "kcat";

  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "kcat";
    rev = version;
    sha256 = "sha256-koDhj/RQc9fhfqjrJylhURw6tppPELhLlBGbNVJsii8=";
  };

  nativeBuildInputs = [ pkg-config which ];

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
