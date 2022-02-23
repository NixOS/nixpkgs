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
  version = "0.1.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GSuZne5M1PsRpdhhFlyq0C2PBhfA+Ab8Wwn5BfGgPKA=";
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
