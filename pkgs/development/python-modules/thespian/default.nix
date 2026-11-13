{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "thespian";
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-92krWgkXCmH7Qa0Q+0cY2KKwKjDeJYLA8I0DtSmoRog=";
  };

  build-system = [
    setuptools
  ];

  # Do not run the test suite: it takes a long time and uses
  # significant system resources, including requiring localhost
  # network operations.  Thespian tests are performed via its Travis
  # CI configuration and do not need to be duplicated here.
  doCheck = false;

  pythonImportsCheck = [
    "thespian"
    "thespian.actors"
  ];

  meta = {
    description = "Python Actor concurrency library";
    homepage = "http://thespianpy.com/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kquick ];
  };
}
