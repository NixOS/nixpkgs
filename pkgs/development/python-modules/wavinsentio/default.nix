{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wavinsentio";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YSofEjDehuNlenkAsQzLkX67Um4pkMSeZmVZgNA06vw=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "wavinsentio" ];

  meta = {
    description = "Python module to interact with the Wavin Sentio underfloor heating system";
    homepage = "https://github.com/djerik/wavinsentio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
