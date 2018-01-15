{ stdenv, fetchPypi, buildPythonPackage, lib }:

buildPythonPackage rec {
  version = "3.9.1";
  pname = "thespian";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0b303bv85176xd5mf3q5j549s28wi70ck2xxgj1cvpydh23dzipb";
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
