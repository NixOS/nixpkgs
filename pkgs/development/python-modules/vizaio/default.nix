{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  platformdirs,
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
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "raman325";
    repo = "vizaio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sExJiGM6gdeDE8qYJXsQ1Mnzx+/Iw6Iav2lSoctGlHE=";
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
