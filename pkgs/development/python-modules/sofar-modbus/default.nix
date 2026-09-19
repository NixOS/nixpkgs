{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  modbus-connection,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sofar-modbus";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darkrain-nl";
    repo = "sofar-modbus";
    tag = finalAttrs.version;
    hash = "sha256-Ej5A5mUoOKwIdHP87cnfAQTjUo5sRDDkRtbn2vPFp1A=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [
    hatchling
  ];

  dependencies = [
    modbus-connection
  ]
  ++ modbus-connection.optional-dependencies.tmodbus;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sofar_modbus"
  ];

  meta = {
    description = "Read Sofar Solar inverters over Modbus";
    homepage = "https://github.com/darkrain-nl/sofar-modbus";
    changelog = "https://github.com/darkrain-nl/sofar-modbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
