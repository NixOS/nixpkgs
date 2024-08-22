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
  version = "6.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C4Wfx01vK2xd2K353uTsdAX3PykOyrJXCsY2+DYSKMg=";
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
