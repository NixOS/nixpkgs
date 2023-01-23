{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, perl
, rdkafka
}:

rustPlatform.buildRustPackage rec {
  pname = "kafka-delta-ingest";
  version = "unstable-2021-12-08";

  src = fetchFromGitHub {
    owner = "delta-io";
    repo = pname;
    rev = "c48c854145b5aab1b8f36cc04978880794a2273c";
    sha256 = "sha256-q0jOVZlxMHIhnc8y2N8o7Sl5Eg7DfJ96kXrPIV8RD1Y=";
  };

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildFeatures = [ "dynamic-linking" ];

  buildInputs = [
    openssl
    rdkafka
  ];

  cargoSha256 = "sha256-srSu3Rx58Ee2Y+8MVis1ACXBQ92u1mIvy1DNp0qJ4IA=";

  # many tests seem to require a running kafka instance
  doCheck = false;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A highly efficient daemon for streaming data from Kafka into Delta Lake";
    homepage = "https://github.com/delta-io/kafka-delta-ingest";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbigras ];
  };
}
