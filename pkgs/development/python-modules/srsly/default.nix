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
  version = "0.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0apgm8znc3k79ifja16fvxsxwgpy3n2fvbp7iwf9szizzpjscylp";
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
