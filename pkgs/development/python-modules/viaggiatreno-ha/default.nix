{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "viaggiatreno-ha";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "monga";
    repo = "viaggiatreno_ha";
    tag = "v${version}";
    hash = "sha256-XmZVguuZK4pnAqINBWJbyAa5VesrQS6wP1jNPdWqhiQ=";
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
    changelog = "https://github.com/monga/viaggiatreno_ha/releases/tag/${src.tag}";
    description = "Viaggiatreno API wrapper to use with Home Assistant";
    homepage = "https://github.com/monga/viaggiatreno_ha";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
