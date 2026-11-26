{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylondonair";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MichaelMKKelly";
    repo = "pylondonair";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VdNp7LbwiaJHdnr6v9hhinWj0k7RuaBhXvyPn+xcQWQ=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylondonair" ];

  meta = {
    description = "Async Python client for the London Air (Imperial College London) air-quality API";
    homepage = "https://github.com/MichaelMKKelly/pylondonair";
    changelog = "https://github.com/MichaelMKKelly/pylondonair/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
