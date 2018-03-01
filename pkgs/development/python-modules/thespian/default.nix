{ stdenv, fetchPypi, buildPythonPackage, lib }:

buildPythonPackage rec {
  version = "3.9.2";
  pname = "thespian";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "aec9793fecf45bb91fe919dc61b5c48a4aadfb9f94b06cd92883df7952eacf95";
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
