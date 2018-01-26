{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, zope_interface
, zope_exceptions
, zope_testing
, six
}:


buildPythonPackage rec {
  pname = "zope.testrunner";
  version = "4.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "039z9q5i1r6fqzlm224nmaxn896k4a9sb1237dv406ncdldd7jaz";
  };

  patches = [ ./test-selection.patch ];

  propagatedBuildInputs = [ zope_interface zope_exceptions zope_testing six ];

  meta = with stdenv.lib; {
    description = "A flexible test runner with layer support";
    homepage = https://pypi.python.org/pypi/zope.testrunner;
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
