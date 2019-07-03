{ fetchPypi, buildPythonPackage, lib }:

buildPythonPackage rec {
  version = "3.9.9";
  pname = "thespian";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c89e1973465feb88b694f3884d24723932a6b0e4df8d909f61e44ff371af7380";
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
