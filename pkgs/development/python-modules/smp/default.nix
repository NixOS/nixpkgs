{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  cbor2,
  crcmod,
  eval-type-backport,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "smp";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JPHutchins";
    repo = "smp";
    tag = version;
    hash = "sha256-V6TGDG05sebn0IF3j0EbkozfO4X1DL3nnwrGOSh+Wuc=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "smp"
  ];

  meta = {
    description = "Simple Management Protocol (SMP) for remotely managing MCU firmware";
    homepage = "https://github.com/JPHutchins/smp";
    changelog = "https://github.com/JPHutchins/smp/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
