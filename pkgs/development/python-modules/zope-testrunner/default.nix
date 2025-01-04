{
  lib,
  buildPythonPackage,
  fetchPypi,
  zope-interface,
  zope-exceptions,
  zope-testing,
  six,
}:

buildPythonPackage rec {
  pname = "zope.testrunner";
  version = "6.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sReX6XWocHseM7ZUTKz5A3KHiG7leA7P7UvxiZ1CFe8=";
  };

  propagatedBuildInputs = [
    zope-interface
    zope-exceptions
    zope-testing
    six
  ];

  doCheck = false; # custom test modifies sys.path

  meta = with lib; {
    description = "Flexible test runner with layer support";
    mainProgram = "zope-testrunner";
    homepage = "https://pypi.python.org/pypi/zope.testrunner";
    license = licenses.zpl20;
    maintainers = [ ];
  };
}
