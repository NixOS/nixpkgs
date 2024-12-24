{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-psycopg2";
  version = "2.9.21.20241019";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vKibmI0uvRm80IsXfSKod+qLhB3ssQ7RMK/POUBGEvo=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "psycopg2-stubs" ];

  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for psycopg2";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
