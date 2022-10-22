{ lib
, buildPythonPackage
, fetchPypi
, zope-interface
, zope-exceptions
, zope-testing
, six
}:


buildPythonPackage rec {
  pname = "zope.testrunner";
  version = "5.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ahDTg1RZ7tO8hDHyGq9gS8dU/4OSopeXzSDlqUHBQ74=";
  };

  propagatedBuildInputs = [ zope-interface zope-exceptions zope-testing six ];

  doCheck = false; # custom test modifies sys.path

  meta = with lib; {
    description = "A flexible test runner with layer support";
    homepage = "https://pypi.python.org/pypi/zope.testrunner";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
