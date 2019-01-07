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
    sha256 = "1629ckjr4hc4ahi3wdk1a36p8ygwkfn3znybhcq5k86cgnf7f3sn";
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
