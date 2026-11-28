{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ttn-client";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angelnu";
    repo = "thethingsnetwork_python_client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xxgtgrnyNwNaADQ1iEhBEUc4w1a59m2ec8EFhS6QMZQ=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ttn_client" ];

  disabledTests = [
    # Test require network access
    "test_connection_auth_error"
  ];

  meta = {
    description = "Module to fetch/receive and parse uplink messages from The Things Network";
    homepage = "https://github.com/angelnu/thethingsnetwork_python_client";
    changelog = "https://github.com/angelnu/thethingsnetwork_python_client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
