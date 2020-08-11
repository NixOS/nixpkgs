{ lib
, buildPythonApplication
, fetchPypi
, pytest
, nose
}:

buildPythonApplication rec {
  pname = "sybil";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54dfac7b3c043dbf484b832512ad2103089f347b5b12307c63ffb4c287742382";
  };

  checkInputs = [ pytest nose ];

  checkPhase = ''
    py.test tests
  '';

  meta = with lib; {
    description = "Automated testing for the examples in your documentation";
    homepage = "https://github.com/cjw296/sybil";
    license = licenses.mit;
  };
}
