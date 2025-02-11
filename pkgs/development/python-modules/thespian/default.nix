{
  fetchPypi,
  buildPythonPackage,
  lib,
}:

buildPythonPackage rec {
  version = "4.0.0";
  format = "setuptools";
  pname = "thespian";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-92krWgkXCmH7Qa0Q+0cY2KKwKjDeJYLA8I0DtSmoRog=";
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
