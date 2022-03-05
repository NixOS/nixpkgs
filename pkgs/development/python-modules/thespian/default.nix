{ fetchPypi, buildPythonPackage, lib }:

buildPythonPackage rec {
  version = "3.10.6";
  pname = "thespian";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c987a8042ba2303e22371f38a67354593dd81c4c11ba1eba7f6657409288d5ed";
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
