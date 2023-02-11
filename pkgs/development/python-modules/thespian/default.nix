{ fetchPypi, buildPythonPackage, lib }:

buildPythonPackage rec {
  version = "3.10.7";
  pname = "thespian";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-HcHvZtMpBtNXq9Yp2ayeHTuIf7gpBUb6xZqjaECbfgo=";
  };

  # Do not run the test suite: it takes a long time and uses
  # significant system resources, including requiring localhost
  # network operations.  Thespian tests are performed via its Travis
  # CI configuration and do not need to be duplicated here.
  doCheck = false;

  meta = with lib; {
    description = "Python Actor concurrency library";
    homepage = "http://thespianpy.com/";
    license = licenses.mit;
    maintainers = [ maintainers.kquick ];
  };
}
