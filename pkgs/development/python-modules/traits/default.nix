{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "traits";
  version = "7.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d+IgPyvrwG+tphOUdal03JbPLpmZHk/k/9KeNGyg/BM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "traits" ];

  meta = {
    description = "Explicitly typed attributes for Python";
    homepage = "https://pypi.org/project/traits/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
