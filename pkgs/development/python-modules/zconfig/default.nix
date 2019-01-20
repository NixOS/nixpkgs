{ stdenv
, fetchPypi
, buildPythonPackage
, zope_testrunner
, manuel
, docutils
}:

buildPythonPackage rec {
  pname = "ZConfig";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22d7fd3b8b12405f4856898995fd69e40bbe239c4c689502ee6d766a7368f585";
  };

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  buildInputs = [ manuel docutils ];
  propagatedBuildInputs = [ zope_testrunner ];

  meta = with stdenv.lib; {
    description = "Structured Configuration Library";
    homepage = https://pypi.python.org/pypi/ZConfig;
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
