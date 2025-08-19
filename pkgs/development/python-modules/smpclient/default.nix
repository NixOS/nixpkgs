{
  lib,
  async-timeout,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  intelhex,
  poetry-core,
  poetry-dynamic-versioning,
  pyserial,
  pytest-asyncio,
  pytestCheckHook,
  smp,
}:

buildPythonPackage rec {
  pname = "smpclient";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intercreate";
    repo = "smpclient";
    tag = version;
    hash = "sha256-NQRVEvi/B+KdhPIzw8pm22uXpYPkoaatkCNFnEcibzo=";
  };

  pythonRelaxDeps = [
    "bleak"
    "smp"
  ];

  build-system = [
    poetry-core
    poetry-dynamic-versioning
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

  patches = [ ./bleak-compat.patch ];

  pythonImportsCheck = [ "smpclient" ];

  meta = {
    description = "Simple Management Protocol (SMP) Client for remotely managing MCU firmware";
    homepage = "https://github.com/intercreate/smpclient";
    changelog = "https://github.com/intercreate/smpclient/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
