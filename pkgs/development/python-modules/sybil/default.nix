{ lib
, buildPythonApplication
, fetchPypi
, pytest
, nose
}:

buildPythonApplication rec {
  pname = "sybil";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e098ae96c4d3668cd5fb04c160334a4bc3ade9d29177e0206846b75f5ff3e91";
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
