{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "vine";
  version = "5.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-i2LpgdNcQQSSEc9ioKEkLYwe6b0Vuxls44rv1nmeYeA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # https://github.com/celery/vine/issues/106
    "t/unit/test_synchronization.py"
  ];

  pythonImportsCheck = [ "vine" ];

  meta = {
    description = "Python promises";
    homepage = "https://github.com/celery/vine";
    changelog = "https://github.com/celery/vine/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
