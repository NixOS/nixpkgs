{
  lib,
  argparse-dataclass,
  buildPythonPackage,
  configargparse,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-common";
  version = "1.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-common";
    tag = "v${version}";
    hash = "sha256-D3vktJmn1CifdiEg5UPGpBuuigEIb+ja4yklHZA6ytQ=";
  };

  patches = [
    # Upstream PR: https://github.com/snakemake/snakemake-interface-common/pull/89
    (fetchpatch {
      name = "relax-packaging-dependency.patch";
      url = "https://github.com/snakemake/snakemake-interface-common/commit/d585b5c0c7c0ec0df60a1a26d5d413f3ee88e63f.patch";
      hash = "sha256-mZ03mx7W5XpdNzr1aNVyQm7/hPdD7yuYqk7DCR9y7Fw=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    argparse-dataclass
    configargparse
  ];

  pythonImportsCheck = [ "snakemake_interface_common" ];

  # test_snakemake_version: No module named 'snakemake'
  # nativeCheckInputs = [ pytestCheckHook ];

  # enabledTestPaths = [ "tests/tests.py" ];

  meta = {
    description = "Common functions and classes for Snakemake and its plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-common";
    changelog = "https://github.com/snakemake/snakemake-interface-common/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
