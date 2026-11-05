{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "84.2.0.20261104";
  pyproject = true;

  src = fetchPypi {
    pname = "types_setuptools";
    inherit version;
    hash = "sha256-HsdYu+3fiNUvlj/mY76rwhF7aq5zzz0pAtfdDfgb124=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "setuptools-stubs" ];

  meta = {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
