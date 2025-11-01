{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchFromGitHub,
  setuptools,
  distro,
  elasticsearch,
  psutil,
  pyyaml,
  rich,
  textual,
  requests,
  tqdm,
  pydantic,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "tt-tools-common";
  version = "1.4.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-tools-common";
    tag = "v${version}";
    hash = "sha256-MY6yFf580jw7V0rsQyLAi1ZfMjrOLD9bDhltcElLDE0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    distro
    elasticsearch
    psutil
    pyyaml
    rich
    textual
    requests
    tqdm
    pydantic
  ];

  meta = {
    description = "Helper library for common utilities shared across Tentorrent tools";
    homepage = "https://github.com/tenstorrent/tt-tools-common";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
