{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "strip-hints";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gxrk1pr3fd2fw8y4p9mw9vbqaj517f062anwfn2j18345d4n9gg";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/abarker/strip-hints;
    description = "Function and command-line program to strip Python type hints.";
    license = licenses.mit;
  };
}
