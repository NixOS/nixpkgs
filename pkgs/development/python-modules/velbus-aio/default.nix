{
  lib,
  aiofile,
  backoff,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pyserial,
  pyserial-asyncio-fast,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "velbus-aio";
  version = "2026.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = "velbus-aio";
    tag = finalAttrs.version;
    hash = "sha256-bFR4iZdvkY8pg4OzAH7E0vEw7E5kyEII2iLfeG5p3OQ=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofile
    backoff
    beautifulsoup4
    lxml
    pyserial
    pyserial-asyncio-fast
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
