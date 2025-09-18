{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  grpcio,
  grpcio-reflection,
  protobuf,
  pytestCheckHook,
  pytest-grpc,
}:

buildPythonPackage rec {
  pname = "yagrc";
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sparky8512";
    repo = "yagrc";
    tag = "v${version}";
    hash = "sha256-nqUzDJfLsI8n8UjfCuOXRG6T8ibdN6fSGPPxm5RJhQk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    grpcio
    grpcio-reflection
    protobuf
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-grpc
  ];

  # tests fail due to pytest-grpc compatibility issues with newer grpcio versions
  doCheck = false;

  pythonImportsCheck = [ "yagrc" ];

  meta = {
    description = "Yet another gRPC reflection client";
    homepage = "https://github.com/sparky8512/yagrc";
    changelog = "https://github.com/sparky8512/yagrc/releases";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
