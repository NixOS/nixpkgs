{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, zope-testrunner
, manuel
, docutils
, pygments
}:

buildPythonPackage rec {
  pname = "ZConfig";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oo6VoK4zV5V0fsytNbLLcI831Ex/Ml4qyyAemDMLFuU=";
  };

  patches = lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  buildInputs = [ manuel docutils ];
  propagatedBuildInputs = [ zope-testrunner ];
  checkInputs = [ pygments ];

  meta = with lib; {
    description = "Structured Configuration Library";
    homepage = "https://pypi.python.org/pypi/ZConfig";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
