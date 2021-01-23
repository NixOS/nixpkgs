{ lib, stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
, zope_exceptions
, zope_testing
, six
}:


buildPythonPackage rec {
  pname = "zope.testrunner";
  version = "5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "873d6017abadc213992a0c38c786ed020341b6e0fe78d14bc2a684cf5a70de4b";
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
