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
  version = "2.2.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h246zvh2wsqyjlw3a3bwmd1zwrkgpflk4z4i9k3sqp2j1jika54";
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
