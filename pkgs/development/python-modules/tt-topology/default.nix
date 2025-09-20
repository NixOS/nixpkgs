{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  setuptools-scm,
  elasticsearch,
  pydantic,
  pyluwen,
  tt-tools-common,
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

  disabled = pythonOlder "3.13";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    elasticsearch
    pydantic
    pyluwen
    tt-tools-common
    networkx
    matplotlib
  ];

  pythonRemoveDeps = [
    "black"
    "pre-commit"
  ];

  # Remove when https://github.com/tenstorrent/tt-topology/pull/51 is merged
  pythonRelaxDeps = [
    "elasticsearch"
    "networkx"
    "matplotlib"
    "setuptools"
  ];

  # Tests are broken
  dontUsePytestCheck = true;

  meta = {
    description = "Command line utility used to flash multiple NB cards on a system to use specific eth routing configurations";
    homepage = "https://github.com/tenstorrent/tt-topology";
    changelog = "https://github.com/tenstorrent/tt-topology/blob/${src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
