{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, zope_exceptions
, zope_testing
, six
}:


buildPythonPackage rec {
  pname = "zope.testrunner";
  version = "5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/LhQZWGIoM380kmjt9Mw1JsVv7+DoQ8YW//cD6uQE+U=";
  };

  propagatedBuildInputs = [ zope_interface zope_exceptions zope_testing six ];

  doCheck = false; # custom test modifies sys.path

  meta = with lib; {
    description = "A flexible test runner with layer support";
    homepage = "https://pypi.python.org/pypi/zope.testrunner";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
