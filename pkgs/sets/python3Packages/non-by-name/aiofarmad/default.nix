{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiofarmad";
  version = "0.6.7";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "DaanVervacke";
    repo = "aiofarmad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JH8m5nBenUiFQXEraYk42Zy1TCYkp5MKj4pfby9Z++Y=";
  };

  build-system = [ uv-build ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiofarmad" ];

  meta = {
    description = "Unofficial asynchronous Python library to interact with the Mijn Farmad Apotheek API";
    homepage = "https://github.com/DaanVervacke/aiofarmad";
    changelog = "https://github.com/DaanVervacke/aiofarmad/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
