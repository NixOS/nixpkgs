{ lib
, buildPythonApplication
, fetchPypi
, pytest
, nose
}:

buildPythonApplication rec {
  pname = "sybil";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7692ed66e793e5e79ae6a70cf2cf861917ed48eaff0d8adf825e64d85820f251";
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
