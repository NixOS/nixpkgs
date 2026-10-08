{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "siphashc";
  version = "2.8";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "siphashc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZlTBDsb8g04PJe7vQ5AJ0Ndp1CJsN+/R8kM6xA+EtFM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "siphashc" ];

  meta = {
    description = "Python c-module for siphash";
    homepage = "https://github.com/WeblateOrg/siphashc";
    changelog = "https://github.com/WeblateOrg/siphashc/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
