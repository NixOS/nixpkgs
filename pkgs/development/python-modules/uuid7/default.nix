{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "uuid7";
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-jFeqMu50VtPMaMlcRTC8VxZG3vrAGJXPxzVFRJiUpjw=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "uuid_extensions" ];

  meta = {
    changelog = "https://github.com/stevesimmons/uuid7/blob/main/HISTORY.rst";
    description = "UUID versions 6, 7, 8 and more — backport for Python < 3.14 where uuid7 is not in stdlib";
    homepage = "https://github.com/stevesimmons/uuid7";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
