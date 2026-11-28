{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "wapiti-swagger";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wapiti-scanner";
    repo = "wapiti_swagger";
    tag = finalAttrs.version;
    hash = "sha256-TB0nxzAIeroYP2LjgIP2PzJNFem8Rw1ao7wTlPBHCfE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
  ];

  pythonImportsCheck = [ "wapiti_swagger" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Library for parsing and generating request bodies from Swagger/OpenAPI specifications";
    homepage = "https://github.com/wapiti-scanner/wapiti_swagger";
    changelog = "https://github.com/wapiti-scanner/wapiti_swagger/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
