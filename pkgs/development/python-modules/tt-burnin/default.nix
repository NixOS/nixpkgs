{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  jsons,
  pyluwen,
  tt-tools-common,
}:
buildPythonPackage rec {
  pname = "tt-burnin";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-burnin";
    tag = "v${version}";
    hash = "sha256-/tnCLhA6zeUkVYhDtdohrZODwHxNTZbnsWgY2Gt16DQ=";
  };

  # Remove when https://github.com/NixOS/nixpkgs/pull/444714 is merged
  pythonRelaxDeps = [
    "pyluwen"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyluwen
    tt-tools-common
    jsons
  ];

  # There's nothing to check since there's no tests
  doCheck = false;

  meta = {
    description = "Command line utility to run a high power consumption workload on TT devices";
    homepage = "https://github.com/tenstorrent/tt-burnin";
    changelog = "https://github.com/tenstorrent/tt-burnin/blob/${src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
