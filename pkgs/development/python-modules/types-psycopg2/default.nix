{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-psycopg2";
  version = "2.9.21.20260223";
  pyproject = true;

  src = fetchPypi {
    pname = "types_psycopg2";
    inherit version;
    hash = "sha256-eO1w3i5WvGtcJsjB2o6a9U5J/cPJTRUEYJ81GeK4TwI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "psycopg2-stubs" ];

  doCheck = false;

  meta = {
    description = "Typing stubs for psycopg2";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
