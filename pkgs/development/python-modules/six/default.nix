{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "six";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test test_six.py
  '';

  meta = {
    description = "A Python 2 and 3 compatibility library";
    homepage = https://pypi.python.org/pypi/six/;
    license = lib.licenses.mit;
  };
}