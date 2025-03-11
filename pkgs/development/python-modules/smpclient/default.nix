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
}:

buildPythonPackage rec {
  pname = "smpclient";
  version = "4.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intercreate";
    repo = "smpclient";
    rev = version;
    hash = "sha256-qbf0xGK1RYaeEIAsbkZ2cWj/MQrmVwm2IKmOkihxBDE=";
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

  pythonRelaxDeps = [
    "smp"
  ];

  pythonImportsCheck = [
    "smpclient"
  ];

  meta = {
    description = "Simple Management Protocol (SMP) Client for remotely managing MCU firmware";
    homepage = "https://github.com/intercreate/smpclient";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
