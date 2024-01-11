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
  version = "4.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+NZC+6a6mNCGMb4sH3GtGVfAUf70qj0/ufHgjcYdAVY=";
  };

  patches = lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  buildInputs = [ manuel docutils ];
  propagatedBuildInputs = [ zope-testrunner ];
  nativeCheckInputs = [ pygments ];

  meta = with lib; {
    description = "Structured Configuration Library";
    homepage = "https://pypi.python.org/pypi/ZConfig";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
