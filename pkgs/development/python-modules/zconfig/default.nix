{
  lib,
  stdenv,
  buildPythonPackage,
  docutils,
  fetchPypi,
  manuel,
  pygments,
  pytestCheckHook,
  setuptools,
  zope-testrunner,
}:

buildPythonPackage rec {
  pname = "zconfig";
  version = "4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RyIz5RX6Kb5shz54uKK0UMLNJdATPLRZYIN/M/GrT+M=";
  };

  patches = lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'setuptools <= 75.6.0' 'setuptools'
  '';

  build-system = [ setuptools ];

  buildInputs = [
    docutils
    manuel
  ];

  dependencies = [ zope-testrunner ];

  nativeCheckInputs = [
    pygments
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ZConfig" ];

  pytestFlags = [ "-s" ];

  meta = {
    description = "Structured Configuration Library";
    homepage = "https://github.com/zopefoundation/ZConfig";
    changelog = "https://github.com/zopefoundation/ZConfig/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
