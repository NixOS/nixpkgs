{
  buildPythonPackage,
  fetchFromGitHub,
  googleapis-common-protos,
  lib,
  protobuf,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "tesla-protocol";
  version = "6.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "tesla-protocol";
    tag = "@teslemetry/tesla-protocol@${finalAttrs.version}";
    hash = "sha256-UTjCeYvTNTcjlZ2Wbwyd9h6YtGaVvu4l0IrQeCTLZ9Y=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/python";

  build-system = [ setuptools ];

  dependencies = [
    googleapis-common-protos
    protobuf
  ];

  pythonImportsCheck = [ "tesla_protocol" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # testing dependencies isolated is useless and fails
    "tests/test_descriptor_namespace.py::DescriptorNamespaceTests"
  ];

  meta = {
    changelog = "https://github.com/Teslemetry/tesla-protocol/releases/tag/${finalAttrs.src.tag}";
    description = "Tesla vehicle-command, fleet-telemetry and energy protobuf bindings for Python";
    homepage = "https://github.com/Teslemetry/tesla-protocol";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
