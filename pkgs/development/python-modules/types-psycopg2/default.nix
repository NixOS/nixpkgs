{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-psycopg2";
  version = "2.9.21.20240417";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Bdslb0pFn7IaQmuOf8oGVsNTkQX/Agjq9r2vQGo4cIc=";
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
