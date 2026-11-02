{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest-asyncio,
  pytest-httpbin,
  pytestCheckHook,
  pyyaml,
  urllib3,
  wrapt,
}:

buildPythonPackage rec {
  pname = "vcrpy";
  version = "9.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kevin1024";
    repo = "vcrpy";
    tag = "v${version}";
    hash = "sha256-Ya9hUxzfjIf7wtRey63SiCbdtiL8Msb7/o9B+1hFZ94=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    wrapt
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpbin
    pytestCheckHook
    urllib3
  ];

  disabledTestPaths = [ "tests/integration" ];

  disabledTests = [
    "TestVCRConnection"
  ];

  pythonImportsCheck = [ "vcr" ];

  meta = {
    description = "Automatically mock your HTTP interactions to simplify and speed up testing";
    homepage = "https://github.com/kevin1024/vcrpy";
    changelog = "https://github.com/kevin1024/vcrpy/blob/${src.tag}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
