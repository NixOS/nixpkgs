{ stdenv
, fetchPypi
, buildPythonPackage
, zope_testrunner
, manuel
, docutils
}:

buildPythonPackage rec {
  pname = "ZConfig";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "560f779c7dcca0593083cbdb3fac9bfc7974cd5061363e2254844192e5644998";
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
