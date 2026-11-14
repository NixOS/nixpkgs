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

buildPythonPackage (finalAttrs: {
  pname = "vcrpy";
  version = "9.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kevin1024";
    repo = "vcrpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3XRxsPxy1aEuDQdFlhsBbhfjk8C0NO9OKKAfH9+cXk4=";
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
    changelog = "https://github.com/kevin1024/vcrpy/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
