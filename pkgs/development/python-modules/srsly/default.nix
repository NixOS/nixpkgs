{ stdenv
, lib
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
  version = "2.3.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f994a266f6e547c8ffe803cb90baed7ca566831f924e0491402564ba0d185e66";
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

  meta = with stdenv.lib; {
    description = "Modern high-performance serialization utilities for Python";
    homepage = "https://github.com/explosion/srsly";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
