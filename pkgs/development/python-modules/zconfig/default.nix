{ lib
, stdenv
, buildPythonPackage
, docutils
, fetchPypi
, manuel
, pygments
, pythonOlder
, zope-testrunner
}:

buildPythonPackage rec {
  pname = "zconfig";
  version = "4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "ZConfig";
    inherit version;
    hash = "sha256-+NZC+6a6mNCGMb4sH3GtGVfAUf70qj0/ufHgjcYdAVY=";
  };

  patches = lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  buildInputs = [
    manuel
    docutils
  ];

  propagatedBuildInputs = [
    zope-testrunner
  ];

  nativeCheckInputs = [
    pygments
  ];

  meta = with lib; {
    description = "Structured Configuration Library";
    homepage = "https://github.com/zopefoundation/ZConfig";
    changelog = "https://github.com/zopefoundation/ZConfig/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
