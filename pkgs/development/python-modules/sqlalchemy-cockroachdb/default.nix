{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-cockroachdb";
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EZdW65BYVdahE0W5nP6FMDGj/lmKnEvzWo3ayfif6Mw=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    sqlalchemy
  ];

  pythonImportsCheck = [ "sqlalchemy_cockroachdb" ];

  meta = with lib; {
    description = "CockroachDB dialect for SQLAlchemy";
    homepage = "https://pypi.org/project/sqlalchemy-cockroachdb";
    license = licenses.asl20;
    maintainers = with maintainers; [ pinpox ];
  };
}
