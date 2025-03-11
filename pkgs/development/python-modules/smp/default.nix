{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  cbor2,
  crcmod,
  eval-type-backport,
  pydantic,
}:

buildPythonPackage rec {
  pname = "smp";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JPHutchins";
    repo = "smp";
    rev = version;
    hash = "sha256-TjucQm07nbfuFrVOHGOVA/f1rQRQfU8ws8VVC+U/kp8=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    cbor2
    crcmod
    eval-type-backport
    pydantic
  ];

  pythonImportsCheck = [
    "smp"
  ];

  meta = {
    description = "Simple Management Protocol (SMP) for remotely managing MCU firmware";
    homepage = "https://github.com/JPHutchins/smp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
