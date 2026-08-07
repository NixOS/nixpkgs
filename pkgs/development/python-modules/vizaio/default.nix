{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  platformdirs,
  pythonOlder,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  rich,
  tomlkit,
  typer,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "vizaio";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "raman325";
    repo = "vizaio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NgiSbADKscieLGK8tfTD8uXM1df4lnIDL5dP13puigQ=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  optional-dependencies = {
    cli = [
      platformdirs
      rich
      tomlkit
      typer
    ];
    discovery = [ zeroconf ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "vizaio" ];

  meta = {
    description = "Modern async Python client and CLI for Vizio SmartCast devices";
    homepage = "https://github.com/raman325/vizaio";
    changelog = "https://github.com/raman325/vizaio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
    mainProgram = "vizaio";
  };
})
