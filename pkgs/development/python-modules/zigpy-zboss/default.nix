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

buildPythonPackage rec {
  pname = "zigpy-zboss";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kardia-as";
    repo = "zigpy-zboss";
    tag = "v${version}";
    hash = "sha256-mVOuBy/uf4NsWqSfpL/ETLMnUDF5H8x1n8XoNjH5DNY=";
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
    changelog = "https://github.com/kardia-as/zigpy-zboss/releases/tag/v${version}";
    description = "Library for zigpy which communicates with Nordic nRF52 radios";
    homepage = "https://github.com/kardia-as/zigpy-zboss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
