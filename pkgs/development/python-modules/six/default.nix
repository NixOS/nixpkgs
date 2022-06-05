{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "six";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test test_six.py
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  meta = {
    description = "A Python 2 and 3 compatibility library";
    homepage = "https://pypi.python.org/pypi/six/";
    license = lib.licenses.mit;
  };
}
