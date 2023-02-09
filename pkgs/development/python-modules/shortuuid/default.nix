{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "shortuuid";
  version = "1.0.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/HXyYVkUgVqOTLFQGzpRN0XLZu8P1fxvufjD+jSB94k=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "shortuuid"
  ];

  meta = with lib; {
    description = "Library to generate concise, unambiguous and URL-safe UUIDs";
    homepage = "https://github.com/stochastic-technologies/shortuuid/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zagy ];
  };
}
