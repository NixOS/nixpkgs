{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, typing-extensions
, dataclasses
}:

buildPythonPackage rec {
  pname = "simple-di";
  version = "0.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "simple_di";
    inherit version;
    hash = "sha256-GSuZne5M1PsRpdhhFlyq0C2PBhfA+Ab8Wwn5BfGgPKA=";
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

  meta = with lib; {
    description = "Simple dependency injection library";
    homepage = "https://github.com/bentoml/simple_di";
    license = licenses.asl20;
    maintainers = with maintainers; [ sauyon ];
  };
}
