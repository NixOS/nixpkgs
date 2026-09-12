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
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "tesla-protocol";
    tag = "@teslemetry/tesla-protocol@${finalAttrs.version}";
    hash = "sha256-Zii0Hq4ow7tyMD2Vsjj8wMF4xAHIAYUHeum3htWcRx4=";
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

  meta = {
    changelog = "https://github.com/Teslemetry/tesla-protocol/releases/tag/${finalAttrs.src.tag}";
    description = "Tesla vehicle-command, fleet-telemetry and energy protobuf bindings for Python";
    homepage = "https://github.com/Teslemetry/tesla-protocol";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
