{ stdenv, buildPythonApplication, fetchPypi
, pytest, nose }:

buildPythonApplication rec {
  pname   = "sybil";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x8qd5p5qliv8wmdglda2iy3f70i4jg8zqyk8yhklm5hrxm8jdl6";
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
