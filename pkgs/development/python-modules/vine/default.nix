{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "vine";
  version = "5.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i2LpgdNcQQSSEc9ioKEkLYwe6b0Vuxls44rv1nmeYeA=";
  };

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
    changelog = "https://github.com/celery/vine/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
