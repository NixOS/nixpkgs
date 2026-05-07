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
  version = "4.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JPHutchins";
    repo = "smp";
    tag = version;
    hash = "sha256-dATsVGG0b5SBZh7R7NT1deJFDRYi7BwtWzT7/QPjkJw=";
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
