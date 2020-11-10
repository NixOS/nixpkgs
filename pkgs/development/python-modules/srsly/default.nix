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
  version = "2.3.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3dcce93c69ff18e8a8d7decfdfdf8e1fd44c4446cdee8d0e5d545d6b172dc377";
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
