{ lib
, fetchPypi
, buildPythonPackage
, six
, sqlalchemy
, pytest
, flexmock
, mock
, python-dateutil
, pytz
}:

buildPythonPackage rec {
  pname = "SQLAlchemy-Utils";
  version = "0.33.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45ab41c90bfb8dd676e83179be3088b3f2d64b613e3b590187163dd941c22d4c";
  };
  checkInputs = [ pytest flexmock mock python-dateutil pytz ];
  buildInputs = [ six sqlalchemy ];

  meta = with lib; {
    homepage = https://github.com/kvesteri/sqlalchemy-utils;
    description = "Various utility functions and datatypes for SQLAlchemy.";
    license = licenses.bsd3;
    longDescription = ''
      SQLAlchemy-Utils provides custom data types and various utility functions
      for SQLAlchemy.
    '';
    maintainers = [ maintainers.bsima ];
  };
}
