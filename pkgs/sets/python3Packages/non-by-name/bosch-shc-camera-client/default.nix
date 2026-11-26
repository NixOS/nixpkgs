{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  defusedxml,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bosch-shc-camera-client";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosandlt";
    repo = "bosch-shc-camera-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bvDnTmQSNK4uoCljQzeIiFMBCNi9crH1O1cKsKQuZsE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    defusedxml
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bosch_shc_camera_client" ];

  meta = {
    description = "Client library for Bosch Smart Home Camera cloud and local APIs";
    homepage = "https://github.com/mosandlt/bosch-shc-camera-client";
    changelog = "https://github.com/mosandlt/bosch-shc-camera-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
