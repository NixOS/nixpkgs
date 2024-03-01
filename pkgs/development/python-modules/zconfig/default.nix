{ lib
, stdenv
, buildPythonPackage
, docutils
, fetchPypi
, manuel
, pygments
, pytestCheckHook
, pythonOlder
, setuptools
, zope-testrunner
}:

buildPythonPackage rec {
  pname = "zconfig";
  version = "4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "ZConfig";
    inherit version;
    hash = "sha256-+NZC+6a6mNCGMb4sH3GtGVfAUf70qj0/ufHgjcYdAVY=";
  };

  patches = lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    docutils
    manuel
  ];

  propagatedBuildInputs = [
    zope-testrunner
  ];

  nativeCheckInputs = [
    pygments
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ZConfig"
  ];

  pytestFlagsArray = [
    "-s"
  ];

  meta = with lib; {
    description = "Structured Configuration Library";
    homepage = "https://github.com/zopefoundation/ZConfig";
    changelog = "https://github.com/zopefoundation/ZConfig/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
