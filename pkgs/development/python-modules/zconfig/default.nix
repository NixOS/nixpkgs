{
  lib,
  stdenv,
  buildPythonPackage,
  docutils,
  fetchPypi,
  manuel,
  pygments,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  zope-testrunner,
}:

buildPythonPackage rec {
  pname = "zconfig";
  version = "4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oOS1J3xM7oBgzjNaV4rEWPgsJArpaxZlkgDbxNmL/M4=";
  };

  patches = lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

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

  pytestFlagsArray = [ "-s" ];

  meta = with lib; {
    description = "Structured Configuration Library";
    homepage = "https://github.com/zopefoundation/ZConfig";
    changelog = "https://github.com/zopefoundation/ZConfig/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = [ ];
  };
}
