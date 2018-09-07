{ stdenv
, fetchPypi
, buildPythonPackage
, zope_testrunner
, manuel
, docutils
}:

buildPythonPackage rec {
  pname = "ZConfig";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de0a802e5dfea3c0b3497ccdbe33a5023c4265f950f33e35dd4cf078d2a81b19";
  };

  patches = [ ./skip-broken-test.patch ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  buildInputs = [ manuel docutils ];
  propagatedBuildInputs = [ zope_testrunner ];

  meta = with stdenv.lib; {
    description = "Structured Configuration Library";
    homepage = https://pypi.python.org/pypi/ZConfig;
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
