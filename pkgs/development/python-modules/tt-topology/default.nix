{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  setuptools-scm,
  black,
  elasticsearch,
  pydantic,
  pyluwen,
  tt-tools-common,
  pre-commit,
  networkx,
  matplotlib,
}:
buildPythonPackage rec {
  pname = "tt-topology";
  version = "1.2.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-topology";
    tag = "v${version}";
    hash = "sha256-hjUQMBTShdbl/tRlFF55P3kQDHi5gsGQVcGZSDgA0as=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    black
    elasticsearch
    pydantic
    pyluwen
    tt-tools-common
    pre-commit
    networkx
    matplotlib
    setuptools
  ];

  # Remove when https://github.com/tenstorrent/tt-topology/pull/51 is merged
  pythonRelaxDeps = [
    "black"
    "elasticsearch"
    "pre-commit"
    "networkx"
    "matplotlib"
    "setuptools"
  ];

  # Tests are broken
  dontUsePytestCheck = true;

  meta = {
    description = "Command line utility used to flash multiple NB cards on a system to use specific eth routing configurations.";
    homepage = "https://github.com/tenstorrent/tt-topology";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
