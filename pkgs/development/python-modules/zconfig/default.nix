{
  lib,
  stdenv,
  buildPythonPackage,
  docutils,
  fetchPypi,
  manuel,
  pytestCheckHook,
  setuptools,
  zope-testrunner,
}:

buildPythonPackage rec {
  pname = "zconfig";
  version = "4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tqed2hV/NpjIdo0s7cJjIW6K8kDTz50JoCpkKREU6yA=";
  };

  patches = lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  build-system = [ setuptools ];

  nativeCheckInputs = [
    docutils
    manuel
    pytestCheckHook
    zope-testrunner
  ];

  pythonImportsCheck = [ "ZConfig" ];

  pytestFlagsArray = [ "-s" ];

  meta = {
    description = "Structured Configuration Library";
    homepage = "https://github.com/zopefoundation/ZConfig";
    changelog = "https://github.com/zopefoundation/ZConfig/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
