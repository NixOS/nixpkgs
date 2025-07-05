{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zwave-js-server-python";
  version = "0.65.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "zwave-js-server-python";
    tag = version;
    hash = "sha256-X7QXHxoMryicc/ouImxg2iMtJEnXI7UHxjtbEPAZ4F4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pydantic
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zwave_js_server" ];

  meta = with lib; {
    description = "Python wrapper for zwave-js-server";
    homepage = "https://github.com/home-assistant-libs/zwave-js-server-python";
    changelog = "https://github.com/home-assistant-libs/zwave-js-server-python/releases/tag/${src.tag}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "zwave-js-server-python";
  };
}
