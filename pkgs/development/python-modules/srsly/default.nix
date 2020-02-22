{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, mock
, numpy
, pathlib
, pytest
, pytz
}:

buildPythonPackage rec {
  pname = "srsly";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d49a90gsfyxwp8g14mvvw1kjm77qgx86zg4812kcmlz9ycb80hi";
  };

  propagatedBuildInputs = lib.optional (pythonOlder "3.4") pathlib;

  checkInputs = [
    mock
    numpy
    pytest
    pytz
  ];

  # TypeError: cannot serialize '_io.BufferedRandom' object
  # Possibly because of sandbox restrictions.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Modern high-performance serialization utilities for Python";
    homepage = https://github.com/explosion/srsly;
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
