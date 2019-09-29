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
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l9yjp1w2vrkrynxrlrc0v47i2iq9059k4ni44nz23573xbdrh2w";
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
