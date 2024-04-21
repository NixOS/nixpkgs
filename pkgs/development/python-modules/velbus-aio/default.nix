{
  lib,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pyserial,
  pyserial-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "velbus-aio";
  version = "2024.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = "velbus-aio";
    rev = "refs/tags/${version}";
    hash = "sha256-rskWnH5zFvBuNL5eJ8O4D6htRP/XtFcq1xH8ZXzT1I4=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    backoff
    pyserial
    pyserial-asyncio
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
