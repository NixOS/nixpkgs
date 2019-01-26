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
  version = "4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3856a79ab0e4ff74addc3e6c152b388dddee548345b440767b6361f635bd9b7";
  };

  propagatedBuildInputs = [ zope_interface zope_exceptions zope_testing six ];

  meta = with stdenv.lib; {
    description = "A flexible test runner with layer support";
    homepage = https://pypi.python.org/pypi/zope.testrunner;
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
