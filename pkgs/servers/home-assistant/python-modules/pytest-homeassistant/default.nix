{
  buildPythonPackage,
  home-assistant,
  pyprojectVersionPatchHook,

  # build-system
  setuptools,

  # dependencies
  bleak-retry-connector,
  freezegun,
  paho-mqtt,
  pytest,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-freezer,
  pytest-socket,
  pytest-xdist,
  requests-mock,
  respx,
  syrupy,

  # optional-dependencies
  aiohasupervisor,
  aiousbwatcher,
  bluetooth-adapters,
  bluetooth-auto-recovery,
  bluetooth-data-tools,
  habluetooth,
  serialx,
  infrared-protocols,
  rf-protocols,
}:

buildPythonPackage {
  pname = "pytest-homeassistant";
  pyproject = true;

  inherit (home-assistant) version src;

  sourceRoot = "${home-assistant.src.name}/packages/pytest-homeassistant";

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [
    bleak-retry-connector
    freezegun
    paho-mqtt
    pytest
    pytest-aiohttp
    pytest-asyncio
    pytest-freezer
    pytest-socket
    pytest-xdist
    requests-mock
    respx
    syrupy
  ];

  pythonRelaxDeps = [
    "paho-mqtt"
    "pytest"
    "syrupy"
  ];

  pythonRemoveDeps = [ "homeassistant" ]; # circular

  optional-dependencies = {
    bluetooth = [
      aiohasupervisor
      aiousbwatcher
      bluetooth-adapters
      bluetooth-auto-recovery
      bluetooth-data-tools
      habluetooth
      serialx
    ];
    infrared = [
      infrared-protocols
    ];
    radio-frequency = [
      rf-protocols
    ];
  };

  meta = home-assistant.meta // {
    description = "Pytest fixtures and test helpers for Home Assistant";
  };
}
