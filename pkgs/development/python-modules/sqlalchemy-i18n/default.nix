{ lib
, fetchPypi
, buildPythonPackage
, sqlalchemy
, sqlalchemy-utils
}:

buildPythonPackage rec {
  pname = "SQLAlchemy-i18n";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de33376483a581ca14218d8f57a114466c5f72b674a95839b6c4564a6e67796f";
  };

  propagatedBuildInputs = [
    sqlalchemy
    sqlalchemy-utils
  ];

  # tests require running a postgresql server
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/kvesteri/sqlalchemy-i18n";
    description = "Internationalization extension for SQLAlchemy models";
    license = licenses.bsd3;
  };
}
