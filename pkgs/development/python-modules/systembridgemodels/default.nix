{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "systembridgemodels";
  version = "4.2.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-models";
    tag = version;
    hash = "sha256-k7QENmfw27qxacB6j1F8ywYfZyQC27PvnkWWQayk310=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "systembridgemodels" ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    "test_system"
    "test_update"
  ];

  disabledTestPaths = [
    # https://github.com/timmo001/system-bridge-models/commit/9523179e73b6a13b9987fa861d77bfeeb88203a7
    "tests/test_update.py"
    "tests/test_version.py"
  ];

  pytestFlags = [ "--snapshot-warn-unused" ];

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-models/releases/tag/${version}";
    description = "This is the models package used by the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-models";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
