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
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n0f9kbbz5akpbiqqz4j3p7zqai3zasw8cqai9zj1pv7sn0qn9ar";
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
