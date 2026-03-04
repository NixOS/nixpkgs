{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  aioresponses,
}:

buildPythonPackage (finalAttrs: {
  pname = "uhooapi";
  version = "1.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getuhoo";
    repo = "uhooapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3t9c4KomP5aQlU80AeQ5FK7XtgLWs7PdeDIwscf+k3g=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    aioresponses
  ];

  pythonImportsCheck = [ "uhooapi" ];

  meta = {
    description = "Python client for uHoo APIs";
    homepage = "https://github.com/getuhoo/uhooapi";
    changelog = "https://github.com/getuhoo/uhooapi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
