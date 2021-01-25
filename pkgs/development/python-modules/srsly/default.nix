{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cython
, mock
, numpy
, pathlib
, pytest
, pytz
}:

buildPythonPackage rec {
  pname = "srsly";
  version = "2.3.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f78eaef8d982e98921ce026d4205e652a9333137259f0b621f5c7b579e746e9d";
  };

  nativeBuildInputs = [ cython ];

  checkInputs = [
    mock
    numpy
    pytest
    pytz
  ];

  # TypeError: cannot serialize '_io.BufferedRandom' object
  # Possibly because of sandbox restrictions.
  doCheck = false;

  pythonImportsCheck = [ "srsly" ];

  meta = with lib; {
    description = "Modern high-performance serialization utilities for Python";
    homepage = "https://github.com/explosion/srsly";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
