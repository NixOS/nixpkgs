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
  version = "5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "354a65f6c6fe6c0584e2fcf06d7318e90dc7f7de1b7008d8913733e299317870";
  };

  propagatedBuildInputs = [ zope_interface zope_exceptions zope_testing six ];

  doCheck = false; # custom test modifies sys.path

  meta = with stdenv.lib; {
    description = "A flexible test runner with layer support";
    homepage = "https://pypi.python.org/pypi/zope.testrunner";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
