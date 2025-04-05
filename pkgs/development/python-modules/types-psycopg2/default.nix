{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-psycopg2";
  version = "2.9.21.20250318";
  pyproject = true;

  src = fetchPypi {
    pname = "types_psycopg2";
    inherit version;
    hash = "sha256-626sW/sWrf1fFrgYkYueJqQO3hR+Dyu//fU6bvcCWoc=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "psycopg2-stubs" ];

  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for psycopg2";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
