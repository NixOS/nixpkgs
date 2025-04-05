{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  googleapis-common-protos,
  protobuf,
}:

buildPythonPackage rec {
  pname = "tensorflow-metadata";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "metadata";
    tag = "v${version}";
    hash = "sha256-DD37l5Sqsn6m9mrRagKi/pi3GKjhO1HzEkEfmnhItqI=";
  };

  patches = [ ./build.patch ];

  # Default build pulls in Bazel + extra deps, given the actual build
  # is literally three lines (see below) - replace it with custom build.
  preBuild = ''
    for proto in tensorflow_metadata/proto/v0/*.proto; do
      protoc --python_out=. $proto
    done
  '';

  build-system = [ setuptools ];

  dependencies = [
    absl-py
    googleapis-common-protos
    protobuf
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "tensorflow_metadata" ];

  meta = {
    description = "Standard representations for metadata that are useful when training machine learning models with TensorFlow";
    homepage = "https://github.com/tensorflow/metadata";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
