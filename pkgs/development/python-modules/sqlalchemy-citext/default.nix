{
  lib,
  buildPythonPackage,
  fetchPypi,
  psycopg2,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-citext";
  version = "1.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oXQOaTqaM058j2CucxCD/nXObBYFu5ymZEpvH2OxW3c=";
  };

  propagatedBuildInputs = [
    sqlalchemy

    # not listed in `install_requires`, but is imported in citext/__init__.py
    psycopg2
  ];

  # tests are not packaged in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "citext" ];

  meta = with lib; {
    description = "Sqlalchemy plugin that allows postgres use of CITEXT";
    homepage = "https://github.com/mahmoudimus/sqlalchemy-citext";
    license = licenses.mit;
    maintainers = [ ];
  };
}
