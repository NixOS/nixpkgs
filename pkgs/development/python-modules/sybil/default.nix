{ lib
, buildPythonApplication
, fetchPypi
, pytest
, nose
}:

buildPythonApplication rec {
  pname = "sybil";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd84e68facfcb778298ef50a4d7446d4d9092e9d8596012b12bcb82858fd10e1";
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
