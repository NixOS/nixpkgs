{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  getmac,
  requests,
  semver,
  pytestCheckHook,
  responses,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "vilfo-api-client";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ManneW";
    repo = "vilfo-api-client-python";
    tag = finalAttrs.version;
    hash = "sha256-ZlmriBd+M+54ux/UNYa355mkz808/NxSz7IzmWouA0c=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    getmac
    requests
    semver
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "vilfo" ];

  meta = {
    description = "Simple wrapper client for the Vilfo router API";
    homepage = "https://github.com/ManneW/vilfo-api-client-python";
    changelog = "https://github.com/ManneW/vilfo-api-client-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
