{
  absl-py,
  buildPythonPackage,
  fetchFromGitHub,
  googleapis-common-protos,
  protobuf,
  lib,
}:

buildPythonPackage rec {
  pname = "tensorflow-metadata";
  version = "1.14.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "metadata";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZfX25CaV+tZVdas+n7O6Gqv1GxOP1iwippIXxfhcOfg=";
  };

  patches = [ ./build.patch ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'protobuf>=3.13,<4' 'protobuf>=3.13'
  '';

  # Default build pulls in Bazel + extra deps, given the actual build
  # is literally three lines (see below) - replace it with custom build.
  preBuild = ''
    for proto in tensorflow_metadata/proto/v0/*.proto; do
      protoc --python_out=. $proto
    done
  '';

  propagatedBuildInputs = [
    absl-py
    googleapis-common-protos
    protobuf
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "tensorflow_metadata" ];

  meta = with lib; {
    description = "Standard representations for metadata that are useful when training machine learning models with TensorFlow";
    homepage = "https://github.com/tensorflow/metadata";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
