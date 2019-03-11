{ buildPythonPackage, fetchPypi, h11, enum34, pytest }:

buildPythonPackage rec {
  pname = "wsproto";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd6020d825022247053400306448e161d8740bdd52e328e5553cd9eee089f705";
  };

  propagatedBuildInputs = [ h11 enum34 ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

}
