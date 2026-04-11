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

buildPythonPackage (finalAttrs: {
  pname = "tensorflow-metadata";
  version = "1.17.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "metadata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4xj2JfQryGy7a9ho9/JJtyg+0H5VLQzq9JevOmOWJZk=";
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

  pythonImportsCheck = [
    "tensorflow_metadata"
    "tensorflow_metadata.proto.v0"
    "google.protobuf.runtime_version"
  ];

  meta = {
    description = "Standard representations for metadata that are useful when training machine learning models with TensorFlow";
    homepage = "https://github.com/tensorflow/metadata";
    changelog = "https://github.com/tensorflow/metadata/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
})
