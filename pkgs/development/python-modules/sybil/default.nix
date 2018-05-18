{ stdenv, buildPythonApplication, fetchPypi
, pytest, nose }:

buildPythonApplication rec {
  pname   = "sybil";
  version = "1.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e17e10bac4c56ef5b6752866a7d100f5ae856ff97d805c4d6cac73be80863d3";
  };

  checkInputs = [ pytest nose ];

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Automated testing for the examples in your documentation.";
    homepage    = https://github.com/cjw296/sybil/;
    license     = licenses.mit;
  };
}
