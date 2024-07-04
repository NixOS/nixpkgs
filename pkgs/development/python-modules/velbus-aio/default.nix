{
  lib,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pyserial,
  pyserial-asyncio-fast,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "velbus-aio";
  version = "2024.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = "velbus-aio";
    rev = "refs/tags/${version}";
    hash = "sha256-rOuw1Iw6mGoXNSqxOlBappARzSGIlii03Hd8/3jWiQg=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    backoff
    pyserial
    pyserial-asyncio-fast
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "velbusaio" ];

  meta = with lib; {
    description = "Python library to support the Velbus home automation system";
    homepage = "https://github.com/Cereal2nd/velbus-aio";
    changelog = "https://github.com/Cereal2nd/velbus-aio/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
