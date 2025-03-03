{
  lib,
  aiofile,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pyserial,
  pyserial-asyncio-fast,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "velbus-aio";
  version = "2025.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = "velbus-aio";
    tag = version;
    hash = "sha256-r6j2C+x7BX7EOFdrQ/N5/NRjHFgyxiQlq/cXnnCg73s=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofile
    backoff
    pyserial
    pyserial-asyncio-fast
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "velbusaio" ];

  meta = with lib; {
    description = "Python library to support the Velbus home automation system";
    homepage = "https://github.com/Cereal2nd/velbus-aio";
    changelog = "https://github.com/Cereal2nd/velbus-aio/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
