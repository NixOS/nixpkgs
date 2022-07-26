{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "shortuuid";
  version = "1.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RZ8S+hrMNP8hOxNxRnwDJRaWRaMe2YniaIcjOa91Y9U=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "shortuuid"
  ];

  pytestFlagsArray = [
    "shortuuid/tests.py"
  ];

  meta = with lib; {
    description = "Library to generate concise, unambiguous and URL-safe UUIDs";
    homepage = "https://github.com/stochastic-technologies/shortuuid/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zagy ];
  };
}
