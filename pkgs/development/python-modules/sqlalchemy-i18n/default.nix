{ stdenv
, lib
, fetchPypi
, buildPythonPackage
, sqlalchemy
, sqlalchemy-utils
, psycopg2
}:

buildPythonPackage rec {
  pname = "SQLAlchemy-i18n";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15xah8643p29kciz365ixs9pbsflj92pzr2d9anbdh2biyf4cka8";
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
