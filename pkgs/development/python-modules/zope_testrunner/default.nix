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
  version = "4.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2aa89531db6b7546e46be9d6113ac835a075f4dcb26e32c7276f4f30d4b14a5";
  };

  propagatedBuildInputs = [ zope_interface zope_exceptions zope_testing six ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "A flexible test runner with layer support";
    homepage = https://pypi.python.org/pypi/zope.testrunner;
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
