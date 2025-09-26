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
  postUnpack = ''
    sed -i 's/pyluwen>=0.7.11/pyluwen>=0.7.10/g' $sourceRoot/pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyluwen
    tt-tools-common
    jsons
  ];

  meta = {
    description = "Command line utility to run a high power consumption workload on TT devices.";
    homepage = "https://github.com/tenstorrent/tt-burnin";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
