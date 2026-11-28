{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  modbus-connection,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  rich,
  syrupy,
  textual,
  textual-plotext,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "solaredged";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-solaredged";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5pRVETwRVcNVpBzq28hNrKo6JdaqxZ/kJAztWtXk7vk=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    modbus-connection
  ];

  optional-dependencies = {
    cli = [
      rich
      textual
      textual-plotext
      typer
    ];
    pymodbus = modbus-connection.optional-dependencies.pymodbus;
    tmodbus = modbus-connection.optional-dependencies.tmodbus;
  };

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytestCheckHook
    syrupy
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [
    "solaredged"
  ];

  meta = {
    description = "Asynchronous Python client for SolarEdge inverters over Modbus";
    homepage = "https://github.com/frenck/python-solaredged";
    changelog = "https://github.com/frenck/python-solaredged/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
