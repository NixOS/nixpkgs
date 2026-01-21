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
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-tools-common";
    tag = "v${version}";
    hash = "sha256-xy1UxETmuuqDmZYf67+qx8Yr8tWQ6VKmjb3md8IaInE=";
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
