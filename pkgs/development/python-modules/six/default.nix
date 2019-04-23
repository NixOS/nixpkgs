{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "six";
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73";
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