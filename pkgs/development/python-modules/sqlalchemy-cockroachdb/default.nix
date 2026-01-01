{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-cockroachdb";
  version = "2.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "sqlalchemy_cockroachdb";
    inherit version;
    hash = "sha256-SLdj/9iypNydVkWZNKVtfV/61BXG5o0RS67l0Sz3nB0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    sqlalchemy
  ];

  pythonImportsCheck = [ "sqlalchemy_cockroachdb" ];

<<<<<<< HEAD
  meta = {
    description = "CockroachDB dialect for SQLAlchemy";
    homepage = "https://github.com/cockroachdb/sqlalchemy-cockroachdb/tree/master/sqlalchemy_cockroachdb";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pinpox ];
=======
  meta = with lib; {
    description = "CockroachDB dialect for SQLAlchemy";
    homepage = "https://github.com/cockroachdb/sqlalchemy-cockroachdb/tree/master/sqlalchemy_cockroachdb";
    license = licenses.asl20;
    maintainers = with maintainers; [ pinpox ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
