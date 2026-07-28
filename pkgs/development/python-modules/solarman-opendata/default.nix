{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "solarman-opendata";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "solarmanpv";
    repo = "solarman-opendata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mLwvAs+RFaHXjOgMaIhKKTU4Dqzdu/pLtAwYc/B6oj4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "solarman_opendata" ];

  meta = {
    description = "Asynchronous Python API for Solarman devices";
    homepage = "https://github.com/solarmanpv/solarman-opendata";
    changelog = "https://github.com/solarmanpv/solarman-opendata/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
