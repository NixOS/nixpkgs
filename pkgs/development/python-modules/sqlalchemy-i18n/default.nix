{
  lib,
  fetchPypi,
  buildPythonPackage,
  sqlalchemy,
  sqlalchemy-utils,
  six,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-i18n";
  version = "1.1.0";

  src = fetchPypi {
    pname = "SQLAlchemy-i18n";
    inherit version;
    hash = "sha256-3jM3ZIOlgcoUIY2PV6EURmxfcrZ0qVg5tsRWSm5neW8=";
  };

  propagatedBuildInputs = [
    sqlalchemy
    sqlalchemy-utils
    six
  ];

  # tests require running a postgresql server
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/kvesteri/sqlalchemy-i18n";
    description = "Internationalization extension for SQLAlchemy models";
    license = licenses.bsd3;
  };
}
