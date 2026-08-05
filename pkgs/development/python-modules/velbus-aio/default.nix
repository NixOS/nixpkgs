{
  lib,
  aiofile,
  anyio,
  backoff,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytest-asyncio,
  pytestCheckHook,
  serialx,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "velbus-aio";
  version = "2026.7.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = "velbus-aio";
    tag = finalAttrs.version;
    hash = "sha256-KCc2jhwk0YNGpyUf2hDv4iaHzRBuFTfXLQJv78MkA5Q=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofile
    anyio
    backoff
    beautifulsoup4
    lxml
    serialx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "velbusaio" ];

  meta = {
    description = "Python library to support the Velbus home automation system";
    homepage = "https://github.com/Cereal2nd/velbus-aio";
    changelog = "https://github.com/Cereal2nd/velbus-aio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
