{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  async-timeout,
  bleak,
  intelhex,
  pyserial,
  smp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "smpclient";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intercreate";
    repo = "smpclient";
    tag = version;
    hash = "sha256-Z0glcCy3JsL45iT8Q82Vtxozi3hv6xaRJvJ3BkHX4PQ=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    async-timeout
    bleak
    intelhex
    pyserial
    smp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "smp"
  ];

  pythonImportsCheck = [
    "smpclient"
  ];

  meta = {
    description = "Simple Management Protocol (SMP) Client for remotely managing MCU firmware";
    homepage = "https://github.com/intercreate/smpclient";
    changelog = "https://github.com/intercreate/smpclient/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
