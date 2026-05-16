{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytest-aiohttp,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "zwave-js-server-python";
  version = "0.69.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "zwave-js-server-python";
    tag = finalAttrs.version;
    hash = "sha256-EBhIoCWclKhxwmqI6fvtsVh3zCnWS5jRXP5aYY3aNbM=";
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

  meta = {
    description = "Python wrapper for zwave-js-server";
    homepage = "https://github.com/home-assistant-libs/zwave-js-server-python";
    changelog = "https://github.com/home-assistant-libs/zwave-js-server-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "zwave-js-server-python";
  };
})
