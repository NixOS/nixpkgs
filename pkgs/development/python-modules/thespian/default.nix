{ fetchPypi, buildPythonPackage, lib }:

buildPythonPackage rec {
  version = "3.9.5";
  pname = "thespian";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "4de3d599d898bf22a311248e749bb21920a8b0f6139f80489352bcb950835db2";
  };

  # Do not run the test suite: it takes a long time and uses
  # significant system resources, including requiring localhost
  # network operations.  Thespian tests are performed via its Travis
  # CI configuration and do not need to be duplicated here.
  doCheck = false;

  meta = with lib; {
    description = "Python Actor concurrency library";
    homepage = http://thespianpy.com/;
    license = licenses.mit;
    maintainers = [ maintainers.kquick ];
  };
}
