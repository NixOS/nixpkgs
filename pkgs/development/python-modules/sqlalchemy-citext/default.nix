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
    sha256 = "a1740e693a9a334e7c8f60ae731083fe75ce6c1605bb9ca6644a6f1f63b15b77";
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
    description = "A sqlalchemy plugin that allows postgres use of CITEXT";
    homepage = "https://github.com/mahmoudimus/sqlalchemy-citext";
    license = licenses.mit;
    maintainers = [ ];
  };
}
