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
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darkrain-nl";
    repo = "sofar-modbus";
    tag = finalAttrs.version;
    hash = "sha256-rigrnxn/eHu98S0RHDdJXs7zx5RovCpQnsvqUCkY0yo=";
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
