{ stdenv
, fetchPypi
, buildPythonPackage
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "ZConfig";
  version = "3.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de0a802e5dfea3c0b3497ccdbe33a5023c4265f950f33e35dd4cf078d2a81b19";
  };

  patches = [ ./skip-broken-test.patch ];

  propagatedBuildInputs = [ zope_testrunner ];

  meta = with stdenv.lib; {
    description = "Structured Configuration Library";
    homepage = http://pypi.python.org/pypi/ZConfig;
    license = licenses.zpt20;
    maintainers = [ maintainers.goibhniu ];
  };
}
