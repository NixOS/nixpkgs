{ stdenv, fetchPypi, buildPythonPackage, lib }:

buildPythonPackage rec {
  version = "3.9.0";
  pname = "thespian";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "e698e3c5369d7b06de5c4ce7b877ea65991c99f7b0fabd09f29e91bc981c7d22";
  };

  # Do not run the test suite: it takes a long type and uses
  # significant system resources, including requiring localhost
  # network operations.  Thespian tests are performed via it's Travis
  # CI configuration and do not need to be duplicated here.
  doCheck = false;

  meta = with lib; {
    description = "Python Actor concurrency library";
    homepage = http://thespianpy.com/;
    license = licenses.mit;
    maintainers = [ maintainers.kquick ];
  };
}
