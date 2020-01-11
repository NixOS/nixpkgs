{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "six";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test test_six.py
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  meta = {
    description = "A Python 2 and 3 compatibility library";
    homepage = https://pypi.python.org/pypi/six/;
    license = lib.licenses.mit;
  };
}