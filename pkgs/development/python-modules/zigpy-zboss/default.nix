{
  buildPythonPackage,
  coloredlogs,
  fetchFromGitHub,
  jsonschema,
  lib,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  serialx,
  setuptools,
  voluptuous,
  zigpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "zigpy-zboss";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kardia-as";
    repo = "zigpy-zboss";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NXla0X1WUg07Px/ZYrmldfXEqYJ/xIryz79/QMiDVn8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    coloredlogs
    jsonschema
    serialx
    voluptuous
    zigpy
  ];

  pythonImportsCheck = [ "zigpy_zboss" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/kardia-as/zigpy-zboss/releases/tag/${finalAttrs.src.tag}";
    description = "Library for zigpy which communicates with Nordic nRF52 radios";
    homepage = "https://github.com/kardia-as/zigpy-zboss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
