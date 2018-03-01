{ stdenv, buildPythonApplication, fetchPypi
, pytest, nose }:

buildPythonApplication rec {
  pname   = "sybil";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86332553392f865403883e44695bd8d9d47fe3887c01e17591955237b8fd2d8f";
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
