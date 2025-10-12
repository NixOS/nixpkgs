{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  distro,
  elasticsearch,
  pydantic,
  pyluwen,
  rich,
  textual,
  pre-commit,
  importlib-resources,
  tt-tools-common,
  tomli,
}:
buildPythonPackage rec {
  pname = "tt-smi";
  version = "3.0.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-smi";
    tag = "v${version}";
    hash = "sha256-C6CfcS0H3rFew/Y1uhmzICdFp1UYU7H9h3YPeAKlcbE=";
  };

  disabled = pythonOlder "3.13";

  build-system = [
    setuptools
  ];

  dependencies = [
    distro
    elasticsearch
    pydantic
    pyluwen
    rich
    textual
    pre-commit
    importlib-resources
    tt-tools-common
    setuptools
    tomli
  ];

  # Fails due to having no tests
  dontUsePytestCheck = true;

  meta = {
    description = "Tenstorrent console based hardware information program";
    homepage = "https://github.com/tenstorrent/tt-smi";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
