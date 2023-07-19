{ lib
, buildPythonPackage
, fetchPypi
, lxml
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tableaudocumentapi";
  version = "0.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g6V1UBf+P21FcZkR3PHoUmdmrQwEvjdd1VKhvNmvOys=";
  };

  propagatedBuildInputs = [
    lxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tableaudocumentapi"
  ];

  # ModuleNotFoundError: No module named 'test.assets'
  doCheck = false;

  meta = with lib; {
    description = "Python module for working with Tableau files";
    homepage = "https://github.com/tableau/document-api-python";
    changelog = "https://github.com/tableau/document-api-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
