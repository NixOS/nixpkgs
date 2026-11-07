{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "viaggiatreno-ha";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "monga";
    repo = "viaggiatreno_ha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DHsxkj/tMgPrFtV4AlAA+W0jLTtaprNYGqG+U6FTSUk=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cd tests
  '';

  # Tests use aiohttp's AioHTTPTestCase which starts a local TCP server
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "viaggiatreno_ha" ];

  meta = {
    description = "Viaggiatreno API wrapper to use with Home Assistant";
    homepage = "https://github.com/monga/viaggiatreno_ha";
    changelog = "https://github.com/monga/viaggiatreno_ha/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
