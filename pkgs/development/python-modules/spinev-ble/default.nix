{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
  bleak,
  bleak-retry-connector,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "spinev-ble";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Dr-Blank";
    repo = "spinev-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xQtSoFN5jktW5M+ZIwdRQCcHe4ocLH4YiSogviz4v1E=";
  };

  build-system = [ hatchling ];

  optional-dependencies.bleak = [
    bleak
    bleak-retry-connector
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.bleak;

  pythonImportsCheck = [ "spinev_ble" ];

  meta = {
    description = "Local Bluetooth LE control for Exicom Spin EV chargers";
    homepage = "https://github.com/Dr-Blank/spinev-ble";
    changelog = "https://github.com/Dr-Blank/spinev-ble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
    mainProgram = "spinev-ble";
  };
})
