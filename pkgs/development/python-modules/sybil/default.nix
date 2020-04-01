{ lib
, buildPythonApplication
, fetchPypi
, pytest
, nose
}:

buildPythonApplication rec {
  pname = "sybil";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x34mzxvxj1kkld7sz9n90pdcinxcan56jg6cnnwkv87v7s1vna6";
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
