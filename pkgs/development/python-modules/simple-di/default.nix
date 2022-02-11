{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, typing-extensions
, dataclasses
}:

buildPythonPackage rec {
  pname = "simple_di";
  version = "0.1.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2667f2b9095e86c7726b3853c30b37f527f7d247282c7dd0b3428a7fb5d1a8a9";
  };

  propagatedBuildInputs = [
    setuptools
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.7") [
    dataclasses
  ];

  pythonImportsCheck = [
    "simple_di"
  ];

  # pypi distribution contains no tests
  doCheck = false;

  meta = {
    description = "Simple dependency injection library";
    homepage = "https://github.com/bentoml/simple_di";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sauyon ];
  };
}
