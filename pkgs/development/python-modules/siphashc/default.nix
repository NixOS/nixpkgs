{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "siphashc";
  version = "2.9.1";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "siphashc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z0tLAo1mcbC4A/hPBcN6SyvzTpHiigMeqHSaOhSjqbY=";
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
