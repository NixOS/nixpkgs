{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-psycopg2";
  version = "2.9.21.20240819";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tta0dGTWN0+mTl47I0zqD3EOchI6RZbWerULdBWoRmY=";
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
