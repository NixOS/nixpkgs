{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "simple-di";
  version = "0.1.5";
  format = "setuptools";

  src = fetchPypi {
    pname = "simple_di";
    inherit version;
    hash = "sha256-GSuZne5M1PsRpdhhFlyq0C2PBhfA+Ab8Wwn5BfGgPKA=";
  };

  propagatedBuildInputs = [
    setuptools
    typing-extensions
  ];

  pythonImportsCheck = [ "simple_di" ];

  # pypi distribution contains no tests
  doCheck = false;

  meta = {
    description = "Simple dependency injection library";
    homepage = "https://github.com/bentoml/simple_di";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sauyon ];
  };
}
