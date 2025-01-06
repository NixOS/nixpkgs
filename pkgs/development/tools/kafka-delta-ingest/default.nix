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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "deltalake-0.4.1" = "sha256-0v3n+qMbBhw53qPuZdhGSO+aqc6j8T577fnyEIQmPDU=";
    };
  };

  # many tests seem to require a running kafka instance
  doCheck = false;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Highly efficient daemon for streaming data from Kafka into Delta Lake";
    mainProgram = "kafka-delta-ingest";
    homepage = "https://github.com/delta-io/kafka-delta-ingest";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
