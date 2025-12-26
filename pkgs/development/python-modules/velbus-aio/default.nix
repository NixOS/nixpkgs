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

buildPythonPackage rec {
  pname = "velbus-aio";
  version = "2025.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = "velbus-aio";
    tag = version;
    hash = "sha256-DmS5XvYUXGYLQWoXNlqsQ4tFsdWMqiJhHYokbuZT67c=";
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
    changelog = "https://github.com/Cereal2nd/velbus-aio/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
