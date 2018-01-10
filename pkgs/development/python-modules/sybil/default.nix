{ stdenv, buildPythonApplication, fetchPypi
, pytest, nose }:

buildPythonApplication rec {
  pname   = "sybil";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bd7dd09eff68cbec9062e6950124fadfaaccbc0f50b23c1037f4d70ae86f0f1";
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
