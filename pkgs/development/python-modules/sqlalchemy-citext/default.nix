{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  psycopg2,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqlalchemy-citext";
  version = "1.8.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-oXQOaTqaM058j2CucxCD/nXObBYFu5ymZEpvH2OxW3c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sqlalchemy

    # not listed in `install_requires`, but is imported in citext/__init__.py
    psycopg2
  ];

  # tests are not packaged in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "citext" ];

  meta = {
    description = "Sqlalchemy plugin that allows postgres use of CITEXT";
    homepage = "https://github.com/mahmoudimus/sqlalchemy-citext";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
