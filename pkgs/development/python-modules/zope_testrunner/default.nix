{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
, zope_exceptions
, zope_testing
, six
}:


buildPythonPackage rec {
  pname = "zope.testrunner";
  version = "5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d8a27e214033b6f1e557556e61bff9568ae95676dfcc8a032483fdeeee792c3";
  };

  propagatedBuildInputs = [ zope_interface zope_exceptions zope_testing six ];

  doCheck = false; # custom test modifies sys.path

  meta = with stdenv.lib; {
    description = "A flexible test runner with layer support";
    homepage = https://pypi.python.org/pypi/zope.testrunner;
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
