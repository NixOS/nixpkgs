{ lib
, buildPythonPackage
, case
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "vine";
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i2LpgdNcQQSSEc9ioKEkLYwe6b0Vuxls44rv1nmeYeA=";
  };

  nativeCheckInputs = [
    case
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # pytest.PytestRemovedIn8Warning: Support for nose tests is deprecated and will be removed in a future release.
    "-W" "ignore::pytest.PytestRemovedIn8Warning"
  ];

  pythonImportsCheck = [
    "vine"
  ];

  meta = with lib; {
    description = "Python promises";
    homepage = "https://github.com/celery/vine";
    changelog = "https://github.com/celery/vine/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
