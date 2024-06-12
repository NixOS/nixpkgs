{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-python-dateutil";
  version = "2.9.0.20240316";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XS8uJAuGkF5AlE3Xh9ttqSY/Deq+8Qdt2u15c1HsAgI=";
  };

  nativeBuildInputs = [ setuptools ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "dateutil-stubs" ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
