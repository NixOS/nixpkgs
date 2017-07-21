{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, zope_interface
, zope_exceptions
, zope_testing
, six
, subunit
}:


buildPythonPackage rec {
  pname = "zope.testrunner";
  version = "4.7.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ffcb4989829544a83d27e42b2eeb28f8fc134bd847d71ce8dca54f710526ef0";
    extension = "zip";
  };

  propagatedBuildInputs = [ zope_interface zope_exceptions zope_testing six ] ++ stdenv.lib.optional (!isPy3k) subunit;

  meta = with stdenv.lib; {
    description = "A flexible test runner with layer support";
    homepage = http://pypi.python.org/pypi/zope.testrunner;
    license = licenses.zpt20;
    maintainers = [ maintainers.goibhniu ];
  };
}
