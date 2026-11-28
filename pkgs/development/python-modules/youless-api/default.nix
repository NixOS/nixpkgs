{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "youless-api";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gjong";
    repo = "youless-python-bridge";
    tag = finalAttrs.version;
    hash = "sha256-uYKPn8P8AUtnFdgYEbxrQEgbviNRD8+2PBrO6ehMM1g=";
  };

  env.PUBLISH_VERSION = finalAttrs.version;

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "youless_api" ];

  meta = {
    description = "Python library for YouLess sensors";
    homepage = "https://github.com/gjong/youless-python-bridge";
    changelog = "https://github.com/gjong/youless-python-bridge/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
