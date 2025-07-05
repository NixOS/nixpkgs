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
}:
buildPythonPackage rec {
  pname = "tt-tools-common";
  version = "1.4.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-tools-common";
    tag = "v${version}";
    hash = "sha256-P1cdRqQOOzz9Ax+SqJl5mS1wjZGSBS5tXnaWD1qRNHo=";
  };

  patches = [
    # Remove when https://github.com/tenstorrent/tt-tools-common/pull/30 is merged
    ./loosen-deps.patch
  ];

  build-system = [
    setuptools
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
    description = "This is a space for common utilities shared across Tentorrent tools. This is a helper library and not a standalone tool.";
    homepage = "https://github.com/tenstorrent/tt-tools-common";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
