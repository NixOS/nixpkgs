{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "uart-devices";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "uart-devices";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vBwQXeXw9y7eETtlC4dcqGytIgrAm7iomnvoaxhl6JI=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "uart_devices" ];

  meta = {
    description = "UART Devices for Linux";
    homepage = "https://github.com/bdraco/uart-devices";
    changelog = "https://github.com/bdraco/uart-devices/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
})
