{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uart-devices";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "uart-devices";
    tag = "v${version}";
    hash = "sha256-vBwQXeXw9y7eETtlC4dcqGytIgrAm7iomnvoaxhl6JI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "-Wdefault --cov=uart_devices --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "uart_devices" ];

  meta = with lib; {
    description = "UART Devices for Linux";
    homepage = "https://github.com/bdraco/uart-devices";
    changelog = "https://github.com/bdraco/uart-devices/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
