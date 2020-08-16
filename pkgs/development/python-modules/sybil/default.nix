{ lib
, buildPythonApplication
, fetchPypi
, pytest
, nose
}:

buildPythonApplication rec {
  pname = "sybil";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc46117619f2f704d1d1b02634fa3285f40479a3008172763b9998fe964f4d11";
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
