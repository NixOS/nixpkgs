{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cython
, catalogue
, mock
, numpy
, pathlib
, pytest
, pytz
}:

buildPythonPackage rec {
  pname = "srsly";
  version = "2.4.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e29730be53015970e4a59050e8e9f9be44d762108a617df56c9dfc981b515ab7";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ catalogue ];

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
  };
}
