{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  grpcio,
  protobuf,
  yagrc,
}:

buildPythonPackage rec {
  pname = "starlink-grpc-core";
  version = "1.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sparky8512";
    repo = "starlink-grpc-tools";
    tag = "v${version}";
    hash = "sha256-TXj8cU5abVIA81vEylYgZCIAUk31BppwRdHMl9kOEPQ=";
  };

  pypaBuildFlags = [ "packaging" ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    grpcio
    protobuf
    yagrc
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "starlink_grpc" ];

  meta = {
    description = "Core functions for Starlink gRPC communication";
    homepage = "https://github.com/sparky8512/starlink-grpc-tools";
    changelog = "https://github.com/sparky8512/starlink-grpc-tools/releases/tag/v${version}";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
