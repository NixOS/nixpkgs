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
  version = "4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tqed2hV/NpjIdo0s7cJjIW6K8kDTz50JoCpkKREU6yA=";
  };

  patches = lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  nativeBuildInputs = [ setuptools ];

  buildInputs = [
    docutils
    manuel
  ];

  propagatedBuildInputs = [ zope-testrunner ];

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
    maintainers = with maintainers; [ goibhniu ];
  };
}
